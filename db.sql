-- Kullanıcılar Tablosu
CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    UserName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    PasswordHash NVARCHAR(255) NOT NULL,
    ProfilePicture NVARCHAR(255), -- Kullanıcı profil resmi (isteğe bağlı)
    Bio NVARCHAR(MAX), -- Kullanıcı biyografisi (isteğe bağlı)
    CreatedAt DATETIME DEFAULT GETDATE()
);

-- Tarifler Tablosu
CREATE TABLE Recipes (
    RecipeID INT IDENTITY(1,1) PRIMARY KEY,
    RecipeName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(MAX),
    Instructions NVARCHAR(MAX) NOT NULL, -- Tarif adımları
    PrepTime INT, -- Hazırlık süresi (dakika)
    CookTime INT, -- Pişirme süresi (dakika)
    Servings INT, -- Kaç kişilik olduğu bilgisi
    AuthorID INT,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (AuthorID) REFERENCES Users(UserID) ON DELETE SET NULL
);

-- Malzemeler Tablosu
CREATE TABLE Ingredients (
    IngredientID INT IDENTITY(1,1) PRIMARY KEY,
    IngredientName NVARCHAR(100) NOT NULL UNIQUE,
    Unit NVARCHAR(50) -- Ölçü birimi (ör. gram, adet, bardak)
);

-- Tarif-Malzeme İlişkisi Tablosu
CREATE TABLE RecipeIngredients (
    RecipeIngredientID INT IDENTITY(1,1) PRIMARY KEY,
    RecipeID INT NOT NULL,
    IngredientID INT NOT NULL,
    Quantity DECIMAL(10,2), -- Miktar
    Unit NVARCHAR(50), -- Özel bir birim belirtebilir
    FOREIGN KEY (RecipeID) REFERENCES Recipes(RecipeID) ON DELETE CASCADE,
    FOREIGN KEY (IngredientID) REFERENCES Ingredients(IngredientID) ON DELETE CASCADE
);

-- Yorumlar Tablosu
CREATE TABLE Comments (
    CommentID INT IDENTITY(1,1) PRIMARY KEY,
    RecipeID INT NOT NULL,
    UserID INT NOT NULL,
    CommentText NVARCHAR(MAX) NOT NULL,
    ParentCommentID INT, -- Alt yorumlar için (isteğe bağlı)
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (RecipeID) REFERENCES Recipes(RecipeID) ON DELETE CASCADE,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    FOREIGN KEY (ParentCommentID) REFERENCES Comments(CommentID) ON DELETE NO ACTION
);

-- Puanlama Tablosu
CREATE TABLE Ratings (
    RatingID INT IDENTITY(1,1) PRIMARY KEY,
    RecipeID INT NOT NULL,
    UserID INT NOT NULL,
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (RecipeID) REFERENCES Recipes(RecipeID) ON DELETE CASCADE,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    UNIQUE (RecipeID, UserID) -- Her kullanıcı bir tarife yalnızca bir kez puan verebilir
);

-- Tarif Kategorileri Tablosu
CREATE TABLE Categories (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName NVARCHAR(100) NOT NULL UNIQUE,
    CreatedAt DATETIME DEFAULT GETDATE()
);

-- Tarif-Kategori İlişkisi Tablosu
CREATE TABLE RecipeCategories (
    RecipeCategoryID INT IDENTITY(1,1) PRIMARY KEY,
    RecipeID INT NOT NULL,
    CategoryID INT NOT NULL,
    FOREIGN KEY (RecipeID) REFERENCES Recipes(RecipeID) ON DELETE CASCADE,
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID) ON DELETE CASCADE
);

-- Tarif Favorileri Tablosu
CREATE TABLE Favorites (
    FavoriteID INT IDENTITY(1,1) PRIMARY KEY,
    RecipeID INT NOT NULL,
    UserID INT NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (RecipeID) REFERENCES Recipes(RecipeID) ON DELETE CASCADE,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    UNIQUE (RecipeID, UserID) -- Aynı tarifi bir kullanıcı yalnızca bir kez favorilere ekleyebilir
);

-- Tarif Görselleri Tablosu
CREATE TABLE RecipeImages (
    RecipeImageID INT IDENTITY(1,1) PRIMARY KEY,
    RecipeID INT NOT NULL,
    ImageURL NVARCHAR(255) NOT NULL, -- Resmin yolu veya URL'si
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (RecipeID) REFERENCES Recipes(RecipeID) ON DELETE CASCADE
);

-- Günlük Kullanıcı Aktivitesi Tablosu (isteğe bağlı ek özellik)
CREATE TABLE UserActivity (
    ActivityID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    ActivityType NVARCHAR(50), -- Aktivite türleri
    RecipeID INT,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    FOREIGN KEY (RecipeID) REFERENCES Recipes(RecipeID) ON DELETE CASCADE
);

-- Öneri Sistemi için İlişki Tablosu (isteğe bağlı)
CREATE TABLE RecipeTags (
    TagID INT IDENTITY(1,1) PRIMARY KEY,
    RecipeID INT NOT NULL,
    TagName NVARCHAR(50) NOT NULL,
    FOREIGN KEY (RecipeID) REFERENCES Recipes(RecipeID) ON DELETE CASCADE
);