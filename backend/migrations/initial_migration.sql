-- =====================================================
-- Database Migration: BookNest Initial Schema
-- =====================================================
-- IMPORTANT: Always use [dbo] schema in this file.
-- The migration-runner will automatically replace [dbo] with [project_booknest]
-- at runtime based on the PROJECT_ID environment variable.
-- DO NOT hardcode [project_XXX] - always use [dbo]!
-- DO NOT create schema here - migration-runner creates it programmatically.
-- =====================================================

-- =====================================================
-- TABLES
-- =====================================================

/**
 * @table book Personal library book records
 * @multitenancy true
 * @softDelete true
 * @alias bk
 */
CREATE TABLE [dbo].[book] (
  [idBook] INTEGER IDENTITY(1, 1) NOT NULL,
  [idAccount] INTEGER NOT NULL,
  [idUser] INTEGER NOT NULL,
  [title] NVARCHAR(200) NOT NULL,
  [author] NVARCHAR(100) NOT NULL,
  [yearPublication] INTEGER NULL,
  [genre] NVARCHAR(50) NULL,
  [coverUrl] NVARCHAR(500) NULL,
  [shelf] INTEGER NOT NULL,
  [totalPages] INTEGER NULL,
  [isbn] VARCHAR(20) NULL,
  [dateAdded] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
  [dateCreated] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
  [dateModified] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
  [deleted] BIT NOT NULL DEFAULT 0
);
GO

/**
 * @table bookReview Book reviews and ratings
 * @multitenancy true
 * @softDelete true
 * @alias bkRvw
 */
CREATE TABLE [dbo].[bookReview] (
  [idBookReview] INTEGER IDENTITY(1, 1) NOT NULL,
  [idAccount] INTEGER NOT NULL,
  [idBook] INTEGER NOT NULL,
  [idUser] INTEGER NOT NULL,
  [rating] NUMERIC(3, 1) NOT NULL,
  [reviewText] NVARCHAR(2000) NULL,
  [dateReview] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
  [dateUpdated] DATETIME2 NULL,
  [dateCreated] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
  [dateModified] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
  [deleted] BIT NOT NULL DEFAULT 0
);
GO

/**
 * @table readingProgress Reading progress tracking
 * @multitenancy true
 * @softDelete true
 * @alias rdgPrg
 */
CREATE TABLE [dbo].[readingProgress] (
  [idReadingProgress] INTEGER IDENTITY(1, 1) NOT NULL,
  [idAccount] INTEGER NOT NULL,
  [idBook] INTEGER NOT NULL,
  [idUser] INTEGER NOT NULL,
  [pagesRead] INTEGER NOT NULL DEFAULT 0,
  [percentComplete] NUMERIC(5, 2) NOT NULL DEFAULT 0,
  [dateStarted] DATE NOT NULL,
  [dateLastUpdate] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
  [dateCompleted] DATE NULL,
  [dateCreated] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
  [dateModified] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
  [deleted] BIT NOT NULL DEFAULT 0
);
GO

/**
 * @table annualGoal Annual reading goals
 * @multitenancy true
 * @softDelete true
 * @alias anlGl
 */
CREATE TABLE [dbo].[annualGoal] (
  [idAnnualGoal] INTEGER IDENTITY(1, 1) NOT NULL,
  [idAccount] INTEGER NOT NULL,
  [idUser] INTEGER NOT NULL,
  [year] INTEGER NOT NULL,
  [targetBooks] INTEGER NOT NULL,
  [booksRead] INTEGER NOT NULL DEFAULT 0,
  [percentComplete] NUMERIC(5, 2) NOT NULL DEFAULT 0,
  [dateCreated] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
  [dateModified] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
  [deleted] BIT NOT NULL DEFAULT 0
);
GO

/**
 * @table readingInsight Reading habit insights
 * @multitenancy true
 * @softDelete true
 * @alias rdgIns
 */
CREATE TABLE [dbo].[readingInsight] (
  [idReadingInsight] INTEGER IDENTITY(1, 1) NOT NULL,
  [idAccount] INTEGER NOT NULL,
  [idUser] INTEGER NOT NULL,
  [insightType] INTEGER NOT NULL,
  [description] NVARCHAR(1000) NOT NULL,
  [relatedData] NVARCHAR(MAX) NULL,
  [dateGenerated] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
  [dateCreated] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
  [dateModified] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
  [deleted] BIT NOT NULL DEFAULT 0
);
GO

-- =====================================================
-- PRIMARY KEYS
-- =====================================================

/**
 * @primaryKey pkBook
 * @keyType Object
 */
ALTER TABLE [dbo].[book]
ADD CONSTRAINT [pkBook] PRIMARY KEY CLUSTERED ([idBook]);
GO

/**
 * @primaryKey pkBookReview
 * @keyType Object
 */
ALTER TABLE [dbo].[bookReview]
ADD CONSTRAINT [pkBookReview] PRIMARY KEY CLUSTERED ([idBookReview]);
GO

/**
 * @primaryKey pkReadingProgress
 * @keyType Object
 */
ALTER TABLE [dbo].[readingProgress]
ADD CONSTRAINT [pkReadingProgress] PRIMARY KEY CLUSTERED ([idReadingProgress]);
GO

/**
 * @primaryKey pkAnnualGoal
 * @keyType Object
 */
ALTER TABLE [dbo].[annualGoal]
ADD CONSTRAINT [pkAnnualGoal] PRIMARY KEY CLUSTERED ([idAnnualGoal]);
GO

/**
 * @primaryKey pkReadingInsight
 * @keyType Object
 */
ALTER TABLE [dbo].[readingInsight]
ADD CONSTRAINT [pkReadingInsight] PRIMARY KEY CLUSTERED ([idReadingInsight]);
GO

-- =====================================================
-- CHECK CONSTRAINTS
-- =====================================================

/**
 * @check chkBook_Shelf Shelf validation
 * @enum {0} Quero Ler
 * @enum {1} Lendo
 * @enum {2} Lido
 */
ALTER TABLE [dbo].[book]
ADD CONSTRAINT [chkBook_Shelf] CHECK ([shelf] BETWEEN 0 AND 2);
GO

/**
 * @check chkBook_YearPublication Year validation
 */
ALTER TABLE [dbo].[book]
ADD CONSTRAINT [chkBook_YearPublication] CHECK ([yearPublication] IS NULL OR ([yearPublication] >= 0 AND [yearPublication] <= YEAR(GETUTCDATE())));
GO

/**
 * @check chkBook_TotalPages Pages validation
 */
ALTER TABLE [dbo].[book]
ADD CONSTRAINT [chkBook_TotalPages] CHECK ([totalPages] IS NULL OR [totalPages] > 0);
GO

/**
 * @check chkBookReview_Rating Rating validation
 */
ALTER TABLE [dbo].[bookReview]
ADD CONSTRAINT [chkBookReview_Rating] CHECK ([rating] >= 0 AND [rating] <= 5 AND ([rating] * 2) = CAST([rating] * 2 AS INTEGER));
GO

/**
 * @check chkReadingProgress_PagesRead Pages validation
 */
ALTER TABLE [dbo].[readingProgress]
ADD CONSTRAINT [chkReadingProgress_PagesRead] CHECK ([pagesRead] >= 0);
GO

/**
 * @check chkReadingProgress_PercentComplete Percent validation
 */
ALTER TABLE [dbo].[readingProgress]
ADD CONSTRAINT [chkReadingProgress_PercentComplete] CHECK ([percentComplete] >= 0 AND [percentComplete] <= 100);
GO

/**
 * @check chkAnnualGoal_TargetBooks Target validation
 */
ALTER TABLE [dbo].[annualGoal]
ADD CONSTRAINT [chkAnnualGoal_TargetBooks] CHECK ([targetBooks] > 0 AND [targetBooks] <= 1000);
GO

/**
 * @check chkAnnualGoal_BooksRead Books read validation
 */
ALTER TABLE [dbo].[annualGoal]
ADD CONSTRAINT [chkAnnualGoal_BooksRead] CHECK ([booksRead] >= 0);
GO

/**
 * @check chkAnnualGoal_PercentComplete Percent validation
 */
ALTER TABLE [dbo].[annualGoal]
ADD CONSTRAINT [chkAnnualGoal_PercentComplete] CHECK ([percentComplete] >= 0 AND [percentComplete] <= 100);
GO

/**
 * @check chkReadingInsight_InsightType Insight type validation
 * @enum {0} Ritmo de Leitura
 * @enum {1} Gênero Favorito
 * @enum {2} Autor Favorito
 * @enum {3} Período Mais Produtivo
 * @enum {4} Comparativo Anual
 */
ALTER TABLE [dbo].[readingInsight]
ADD CONSTRAINT [chkReadingInsight_InsightType] CHECK ([insightType] BETWEEN 0 AND 4);
GO

-- =====================================================
-- INDEXES
-- =====================================================

/**
 * @index ixBook_Account Multi-tenancy isolation
 * @type ForeignKey
 */
CREATE NONCLUSTERED INDEX [ixBook_Account]
ON [dbo].[book]([idAccount])
WHERE [deleted] = 0;
GO

/**
 * @index ixBook_Account_User User books lookup
 * @type Search
 */
CREATE NONCLUSTERED INDEX [ixBook_Account_User]
ON [dbo].[book]([idAccount], [idUser])
INCLUDE ([title], [author], [shelf])
WHERE [deleted] = 0;
GO

/**
 * @index ixBook_Account_Shelf Shelf filtering
 * @type Search
 */
CREATE NONCLUSTERED INDEX [ixBook_Account_Shelf]
ON [dbo].[book]([idAccount], [shelf])
INCLUDE ([title], [author], [coverUrl])
WHERE [deleted] = 0;
GO

/**
 * @index uqBook_Account_User_Title_Author Duplicate prevention
 * @type Search
 * @unique true
 */
CREATE UNIQUE NONCLUSTERED INDEX [uqBook_Account_User_Title_Author]
ON [dbo].[book]([idAccount], [idUser], [title], [author])
WHERE [deleted] = 0;
GO

/**
 * @index ixBookReview_Account Multi-tenancy isolation
 * @type ForeignKey
 */
CREATE NONCLUSTERED INDEX [ixBookReview_Account]
ON [dbo].[bookReview]([idAccount])
WHERE [deleted] = 0;
GO

/**
 * @index ixBookReview_Account_Book Book reviews lookup
 * @type ForeignKey
 */
CREATE NONCLUSTERED INDEX [ixBookReview_Account_Book]
ON [dbo].[bookReview]([idAccount], [idBook])
INCLUDE ([rating], [reviewText])
WHERE [deleted] = 0;
GO

/**
 * @index uqBookReview_Account_Book_User One review per user per book
 * @type Search
 * @unique true
 */
CREATE UNIQUE NONCLUSTERED INDEX [uqBookReview_Account_Book_User]
ON [dbo].[bookReview]([idAccount], [idBook], [idUser])
WHERE [deleted] = 0;
GO

/**
 * @index ixReadingProgress_Account Multi-tenancy isolation
 * @type ForeignKey
 */
CREATE NONCLUSTERED INDEX [ixReadingProgress_Account]
ON [dbo].[readingProgress]([idAccount])
WHERE [deleted] = 0;
GO

/**
 * @index ixReadingProgress_Account_Book Book progress lookup
 * @type ForeignKey
 */
CREATE NONCLUSTERED INDEX [ixReadingProgress_Account_Book]
ON [dbo].[readingProgress]([idAccount], [idBook])
INCLUDE ([pagesRead], [percentComplete])
WHERE [deleted] = 0;
GO

/**
 * @index uqReadingProgress_Account_Book_User One progress per user per book
 * @type Search
 * @unique true
 */
CREATE UNIQUE NONCLUSTERED INDEX [uqReadingProgress_Account_Book_User]
ON [dbo].[readingProgress]([idAccount], [idBook], [idUser])
WHERE [deleted] = 0;
GO

/**
 * @index ixAnnualGoal_Account Multi-tenancy isolation
 * @type ForeignKey
 */
CREATE NONCLUSTERED INDEX [ixAnnualGoal_Account]
ON [dbo].[annualGoal]([idAccount])
WHERE [deleted] = 0;
GO

/**
 * @index uqAnnualGoal_Account_User_Year One goal per user per year
 * @type Search
 * @unique true
 */
CREATE UNIQUE NONCLUSTERED INDEX [uqAnnualGoal_Account_User_Year]
ON [dbo].[annualGoal]([idAccount], [idUser], [year])
WHERE [deleted] = 0;
GO

/**
 * @index ixReadingInsight_Account Multi-tenancy isolation
 * @type ForeignKey
 */
CREATE NONCLUSTERED INDEX [ixReadingInsight_Account]
ON [dbo].[readingInsight]([idAccount])
WHERE [deleted] = 0;
GO

/**
 * @index ixReadingInsight_Account_User User insights lookup
 * @type Search
 */
CREATE NONCLUSTERED INDEX [ixReadingInsight_Account_User]
ON [dbo].[readingInsight]([idAccount], [idUser])
INCLUDE ([insightType], [description])
WHERE [deleted] = 0;
GO

-- =====================================================
-- STORED PROCEDURES
-- =====================================================

/**
 * @summary
 * Creates a new book in user's library
 * 
 * @procedure spBookCreate
 * @schema dbo
 * @type stored-procedure
 * 
 * @parameters
 * @param {INT} idAccount - Account identifier
 * @param {INT} idUser - User identifier
 * @param {NVARCHAR(200)} title - Book title
 * @param {NVARCHAR(100)} author - Book author
 * @param {INT} yearPublication - Publication year (optional)
 * @param {NVARCHAR(50)} genre - Book genre (optional)
 * @param {NVARCHAR(500)} coverUrl - Cover image URL (optional)
 * @param {INT} shelf - Shelf category (0=Quero Ler, 1=Lendo, 2=Lido)
 * @param {INT} totalPages - Total pages (optional)
 * @param {VARCHAR(20)} isbn - ISBN code (optional)
 * 
 * @returns {INT} idBook - Created book identifier
 */
CREATE OR ALTER PROCEDURE [dbo].[spBookCreate]
  @idAccount INTEGER,
  @idUser INTEGER,
  @title NVARCHAR(200),
  @author NVARCHAR(100),
  @yearPublication INTEGER = NULL,
  @genre NVARCHAR(50) = NULL,
  @coverUrl NVARCHAR(500) = NULL,
  @shelf INTEGER,
  @totalPages INTEGER = NULL,
  @isbn VARCHAR(20) = NULL
AS
BEGIN
  SET NOCOUNT ON;

  /**
   * @validation Required parameters
   * @throw {titleRequired}
   * @throw {authorRequired}
   */
  IF @title IS NULL OR LTRIM(RTRIM(@title)) = ''
  BEGIN
    ;THROW 51000, 'titleRequired', 1;
  END;

  IF @author IS NULL OR LTRIM(RTRIM(@author)) = ''
  BEGIN
    ;THROW 51000, 'authorRequired', 1;
  END;

  /**
   * @validation Year publication range
   * @throw {yearPublicationInvalid}
   */
  IF @yearPublication IS NOT NULL AND (@yearPublication < 0 OR @yearPublication > YEAR(GETUTCDATE()))
  BEGIN
    ;THROW 51000, 'yearPublicationInvalid', 1;
  END;

  /**
   * @validation Total pages positive
   * @throw {totalPagesMustBePositive}
   */
  IF @totalPages IS NOT NULL AND @totalPages <= 0
  BEGIN
    ;THROW 51000, 'totalPagesMustBePositive', 1;
  END;

  BEGIN TRY
    BEGIN TRAN;

      INSERT INTO [dbo].[book] (
        [idAccount],
        [idUser],
        [title],
        [author],
        [yearPublication],
        [genre],
        [coverUrl],
        [shelf],
        [totalPages],
        [isbn]
      )
      VALUES (
        @idAccount,
        @idUser,
        @title,
        @author,
        @yearPublication,
        @genre,
        @coverUrl,
        @shelf,
        @totalPages,
        @isbn
      );

      DECLARE @idBook INTEGER = SCOPE_IDENTITY();

      /**
       * @rule {fn-reading-progress} Initialize progress when shelf is 'Lendo'
       */
      IF @shelf = 1
      BEGIN
        INSERT INTO [dbo].[readingProgress] (
          [idAccount],
          [idBook],
          [idUser],
          [dateStarted]
        )
        VALUES (
          @idAccount,
          @idBook,
          @idUser,
          CAST(GETUTCDATE() AS DATE)
        );
      END;

      /**
       * @output {BookCreated, 1, 1}
       * @column {INT} idBook - Created book identifier
       */
      SELECT @idBook AS [idBook];

    COMMIT TRAN;
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
    THROW;
  END CATCH;
END;
GO

/**
 * @summary
 * Lists books from user's library with optional filtering
 * 
 * @procedure spBookList
 * @schema dbo
 * @type stored-procedure
 * 
 * @parameters
 * @param {INT} idAccount - Account identifier
 * @param {INT} idUser - User identifier
 * @param {INT} shelf - Filter by shelf (optional, NULL for all)
 * @param {NVARCHAR(100)} searchTerm - Search in title/author (optional)
 */
CREATE OR ALTER PROCEDURE [dbo].[spBookList]
  @idAccount INTEGER,
  @idUser INTEGER,
  @shelf INTEGER = NULL,
  @searchTerm NVARCHAR(100) = NULL
AS
BEGIN
  SET NOCOUNT ON;

  /**
   * @output {BookList, n, n}
   * @column {INT} idBook
   * @column {NVARCHAR(200)} title
   * @column {NVARCHAR(100)} author
   * @column {INT} yearPublication
   * @column {NVARCHAR(50)} genre
   * @column {NVARCHAR(500)} coverUrl
   * @column {INT} shelf
   * @column {INT} totalPages
   * @column {VARCHAR(20)} isbn
   * @column {DATETIME2} dateAdded
   * @column {NUMERIC(3,1)} rating
   * @column {INT} pagesRead
   * @column {NUMERIC(5,2)} percentComplete
   */
  SELECT
    [bk].[idBook],
    [bk].[title],
    [bk].[author],
    [bk].[yearPublication],
    [bk].[genre],
    [bk].[coverUrl],
    [bk].[shelf],
    [bk].[totalPages],
    [bk].[isbn],
    [bk].[dateAdded],
    [bkRvw].[rating],
    [rdgPrg].[pagesRead],
    [rdgPrg].[percentComplete]
  FROM [dbo].[book] [bk]
    LEFT JOIN [dbo].[bookReview] [bkRvw] ON ([bkRvw].[idAccount] = [bk].[idAccount] AND [bkRvw].[idBook] = [bk].[idBook] AND [bkRvw].[deleted] = 0)
    LEFT JOIN [dbo].[readingProgress] [rdgPrg] ON ([rdgPrg].[idAccount] = [bk].[idAccount] AND [rdgPrg].[idBook] = [bk].[idBook] AND [rdgPrg].[deleted] = 0)
  WHERE [bk].[idAccount] = @idAccount
    AND [bk].[idUser] = @idUser
    AND [bk].[deleted] = 0
    AND (@shelf IS NULL OR [bk].[shelf] = @shelf)
    AND (@searchTerm IS NULL OR [bk].[title] LIKE '%' + @searchTerm + '%' OR [bk].[author] LIKE '%' + @searchTerm + '%')
  ORDER BY [bk].[dateAdded] DESC;
END;
GO

/**
 * @summary
 * Gets detailed information about a specific book
 * 
 * @procedure spBookGet
 * @schema dbo
 * @type stored-procedure
 * 
 * @parameters
 * @param {INT} idAccount - Account identifier
 * @param {INT} idBook - Book identifier
 */
CREATE OR ALTER PROCEDURE [dbo].[spBookGet]
  @idAccount INTEGER,
  @idBook INTEGER
AS
BEGIN
  SET NOCOUNT ON;

  /**
   * @validation Book exists
   * @throw {bookNotFound}
   */
  IF NOT EXISTS (SELECT 1 FROM [dbo].[book] WHERE [idBook] = @idBook AND [idAccount] = @idAccount AND [deleted] = 0)
  BEGIN
    ;THROW 51000, 'bookNotFound', 1;
  END;

  /**
   * @output {BookDetail, 1, n}
   * @column {INT} idBook
   * @column {INT} idUser
   * @column {NVARCHAR(200)} title
   * @column {NVARCHAR(100)} author
   * @column {INT} yearPublication
   * @column {NVARCHAR(50)} genre
   * @column {NVARCHAR(500)} coverUrl
   * @column {INT} shelf
   * @column {INT} totalPages
   * @column {VARCHAR(20)} isbn
   * @column {DATETIME2} dateAdded
   * @column {NUMERIC(3,1)} rating
   * @column {NVARCHAR(2000)} reviewText
   * @column {DATETIME2} dateReview
   * @column {INT} pagesRead
   * @column {NUMERIC(5,2)} percentComplete
   * @column {DATE} dateStarted
   * @column {DATE} dateCompleted
   */
  SELECT
    [bk].[idBook],
    [bk].[idUser],
    [bk].[title],
    [bk].[author],
    [bk].[yearPublication],
    [bk].[genre],
    [bk].[coverUrl],
    [bk].[shelf],
    [bk].[totalPages],
    [bk].[isbn],
    [bk].[dateAdded],
    [bkRvw].[rating],
    [bkRvw].[reviewText],
    [bkRvw].[dateReview],
    [rdgPrg].[pagesRead],
    [rdgPrg].[percentComplete],
    [rdgPrg].[dateStarted],
    [rdgPrg].[dateCompleted]
  FROM [dbo].[book] [bk]
    LEFT JOIN [dbo].[bookReview] [bkRvw] ON ([bkRvw].[idAccount] = [bk].[idAccount] AND [bkRvw].[idBook] = [bk].[idBook] AND [bkRvw].[deleted] = 0)
    LEFT JOIN [dbo].[readingProgress] [rdgPrg] ON ([rdgPrg].[idAccount] = [bk].[idAccount] AND [rdgPrg].[idBook] = [bk].[idBook] AND [rdgPrg].[deleted] = 0)
  WHERE [bk].[idBook] = @idBook
    AND [bk].[idAccount] = @idAccount
    AND [bk].[deleted] = 0;
END;
GO

/**
 * @summary
 * Updates book information
 * 
 * @procedure spBookUpdate
 * @schema dbo
 * @type stored-procedure
 * 
 * @parameters
 * @param {INT} idAccount - Account identifier
 * @param {INT} idBook - Book identifier
 * @param {NVARCHAR(200)} title - Book title
 * @param {NVARCHAR(100)} author - Book author
 * @param {INT} yearPublication - Publication year (optional)
 * @param {NVARCHAR(50)} genre - Book genre (optional)
 * @param {NVARCHAR(500)} coverUrl - Cover image URL (optional)
 * @param {INT} totalPages - Total pages (optional)
 * @param {VARCHAR(20)} isbn - ISBN code (optional)
 */
CREATE OR ALTER PROCEDURE [dbo].[spBookUpdate]
  @idAccount INTEGER,
  @idBook INTEGER,
  @title NVARCHAR(200),
  @author NVARCHAR(100),
  @yearPublication INTEGER = NULL,
  @genre NVARCHAR(50) = NULL,
  @coverUrl NVARCHAR(500) = NULL,
  @totalPages INTEGER = NULL,
  @isbn VARCHAR(20) = NULL
AS
BEGIN
  SET NOCOUNT ON;

  /**
   * @validation Book exists
   * @throw {bookNotFound}
   */
  IF NOT EXISTS (SELECT 1 FROM [dbo].[book] WHERE [idBook] = @idBook AND [idAccount] = @idAccount AND [deleted] = 0)
  BEGIN
    ;THROW 51000, 'bookNotFound', 1;
  END;

  /**
   * @validation Required parameters
   * @throw {titleRequired}
   * @throw {authorRequired}
   */
  IF @title IS NULL OR LTRIM(RTRIM(@title)) = ''
  BEGIN
    ;THROW 51000, 'titleRequired', 1;
  END;

  IF @author IS NULL OR LTRIM(RTRIM(@author)) = ''
  BEGIN
    ;THROW 51000, 'authorRequired', 1;
  END;

  BEGIN TRY
    BEGIN TRAN;

      UPDATE [dbo].[book]
      SET
        [title] = @title,
        [author] = @author,
        [yearPublication] = @yearPublication,
        [genre] = @genre,
        [coverUrl] = @coverUrl,
        [totalPages] = @totalPages,
        [isbn] = @isbn,
        [dateModified] = GETUTCDATE()
      WHERE [idBook] = @idBook
        AND [idAccount] = @idAccount;

      /**
       * @output {BookUpdated, 1, 1}
       * @column {BIT} success
       */
      SELECT 1 AS [success];

    COMMIT TRAN;
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
    THROW;
  END CATCH;
END;
GO

/**
 * @summary
 * Moves book to different shelf
 * 
 * @procedure spBookMoveShelf
 * @schema dbo
 * @type stored-procedure
 * 
 * @parameters
 * @param {INT} idAccount - Account identifier
 * @param {INT} idBook - Book identifier
 * @param {INT} newShelf - Target shelf (0=Quero Ler, 1=Lendo, 2=Lido)
 */
CREATE OR ALTER PROCEDURE [dbo].[spBookMoveShelf]
  @idAccount INTEGER,
  @idBook INTEGER,
  @newShelf INTEGER
AS
BEGIN
  SET NOCOUNT ON;

  DECLARE @currentShelf INTEGER;
  DECLARE @idUser INTEGER;

  /**
   * @validation Book exists
   * @throw {bookNotFound}
   */
  SELECT @currentShelf = [shelf], @idUser = [idUser]
  FROM [dbo].[book]
  WHERE [idBook] = @idBook
    AND [idAccount] = @idAccount
    AND [deleted] = 0;

  IF @currentShelf IS NULL
  BEGIN
    ;THROW 51000, 'bookNotFound', 1;
  END;

  BEGIN TRY
    BEGIN TRAN;

      UPDATE [dbo].[book]
      SET
        [shelf] = @newShelf,
        [dateModified] = GETUTCDATE()
      WHERE [idBook] = @idBook
        AND [idAccount] = @idAccount;

      /**
       * @rule {fn-reading-progress} Handle progress when moving to 'Lendo'
       */
      IF @newShelf = 1 AND @currentShelf <> 1
      BEGIN
        IF NOT EXISTS (SELECT 1 FROM [dbo].[readingProgress] WHERE [idBook] = @idBook AND [idAccount] = @idAccount AND [deleted] = 0)
        BEGIN
          INSERT INTO [dbo].[readingProgress] (
            [idAccount],
            [idBook],
            [idUser],
            [dateStarted]
          )
          VALUES (
            @idAccount,
            @idBook,
            @idUser,
            CAST(GETUTCDATE() AS DATE)
          );
        END;
      END;

      /**
       * @rule {fn-reading-progress} Complete progress when moving to 'Lido'
       */
      IF @newShelf = 2 AND @currentShelf <> 2
      BEGIN
        UPDATE [dbo].[readingProgress]
        SET
          [percentComplete] = 100,
          [dateCompleted] = CAST(GETUTCDATE() AS DATE),
          [dateModified] = GETUTCDATE()
        WHERE [idBook] = @idBook
          AND [idAccount] = @idAccount
          AND [deleted] = 0;
      END;

      /**
       * @output {ShelfMoved, 1, 1}
       * @column {BIT} success
       */
      SELECT 1 AS [success];

    COMMIT TRAN;
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
    THROW;
  END CATCH;
END;
GO

/**
 * @summary
 * Deletes a book from library (soft delete)
 * 
 * @procedure spBookDelete
 * @schema dbo
 * @type stored-procedure
 * 
 * @parameters
 * @param {INT} idAccount - Account identifier
 * @param {INT} idBook - Book identifier
 */
CREATE OR ALTER PROCEDURE [dbo].[spBookDelete]
  @idAccount INTEGER,
  @idBook INTEGER
AS
BEGIN
  SET NOCOUNT ON;

  /**
   * @validation Book exists
   * @throw {bookNotFound}
   */
  IF NOT EXISTS (SELECT 1 FROM [dbo].[book] WHERE [idBook] = @idBook AND [idAccount] = @idAccount AND [deleted] = 0)
  BEGIN
    ;THROW 51000, 'bookNotFound', 1;
  END;

  BEGIN TRY
    BEGIN TRAN;

      UPDATE [dbo].[book]
      SET
        [deleted] = 1,
        [dateModified] = GETUTCDATE()
      WHERE [idBook] = @idBook
        AND [idAccount] = @idAccount;

      UPDATE [dbo].[bookReview]
      SET
        [deleted] = 1,
        [dateModified] = GETUTCDATE()
      WHERE [idBook] = @idBook
        AND [idAccount] = @idAccount;

      UPDATE [dbo].[readingProgress]
      SET
        [deleted] = 1,
        [dateModified] = GETUTCDATE()
      WHERE [idBook] = @idBook
        AND [idAccount] = @idAccount;

      /**
       * @output {BookDeleted, 1, 1}
       * @column {BIT} success
       */
      SELECT 1 AS [success];

    COMMIT TRAN;
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
    THROW;
  END CATCH;
END;
GO

/**
 * @summary
 * Creates or updates book review
 * 
 * @procedure spBookReviewSave
 * @schema dbo
 * @type stored-procedure
 * 
 * @parameters
 * @param {INT} idAccount - Account identifier
 * @param {INT} idBook - Book identifier
 * @param {INT} idUser - User identifier
 * @param {NUMERIC(3,1)} rating - Rating (0-5, increments of 0.5)
 * @param {NVARCHAR(2000)} reviewText - Review text (optional)
 */
CREATE OR ALTER PROCEDURE [dbo].[spBookReviewSave]
  @idAccount INTEGER,
  @idBook INTEGER,
  @idUser INTEGER,
  @rating NUMERIC(3, 1),
  @reviewText NVARCHAR(2000) = NULL
AS
BEGIN
  SET NOCOUNT ON;

  DECLARE @shelf INTEGER;

  /**
   * @validation Book exists and is in 'Lido' shelf
   * @throw {bookNotFound}
   * @throw {bookMustBeInReadShelf}
   */
  SELECT @shelf = [shelf]
  FROM [dbo].[book]
  WHERE [idBook] = @idBook
    AND [idAccount] = @idAccount
    AND [deleted] = 0;

  IF @shelf IS NULL
  BEGIN
    ;THROW 51000, 'bookNotFound', 1;
  END;

  IF @shelf <> 2
  BEGIN
    ;THROW 51000, 'bookMustBeInReadShelf', 1;
  END;

  /**
   * @validation Rating range
   * @throw {ratingInvalid}
   */
  IF @rating < 0 OR @rating > 5 OR (@rating * 2) <> CAST(@rating * 2 AS INTEGER)
  BEGIN
    ;THROW 51000, 'ratingInvalid', 1;
  END;

  BEGIN TRY
    BEGIN TRAN;

      DECLARE @idBookReview INTEGER;

      SELECT @idBookReview = [idBookReview]
      FROM [dbo].[bookReview]
      WHERE [idBook] = @idBook
        AND [idAccount] = @idAccount
        AND [idUser] = @idUser
        AND [deleted] = 0;

      IF @idBookReview IS NULL
      BEGIN
        INSERT INTO [dbo].[bookReview] (
          [idAccount],
          [idBook],
          [idUser],
          [rating],
          [reviewText]
        )
        VALUES (
          @idAccount,
          @idBook,
          @idUser,
          @rating,
          @reviewText
        );

        SET @idBookReview = SCOPE_IDENTITY();
      END
      ELSE
      BEGIN
        UPDATE [dbo].[bookReview]
        SET
          [rating] = @rating,
          [reviewText] = @reviewText,
          [dateUpdated] = GETUTCDATE(),
          [dateModified] = GETUTCDATE()
        WHERE [idBookReview] = @idBookReview;
      END;

      /**
       * @output {ReviewSaved, 1, 1}
       * @column {INT} idBookReview
       */
      SELECT @idBookReview AS [idBookReview];

    COMMIT TRAN;
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
    THROW;
  END CATCH;
END;
GO

/**
 * @summary
 * Deletes book review
 * 
 * @procedure spBookReviewDelete
 * @schema dbo
 * @type stored-procedure
 * 
 * @parameters
 * @param {INT} idAccount - Account identifier
 * @param {INT} idBook - Book identifier
 */
CREATE OR ALTER PROCEDURE [dbo].[spBookReviewDelete]
  @idAccount INTEGER,
  @idBook INTEGER
AS
BEGIN
  SET NOCOUNT ON;

  BEGIN TRY
    BEGIN TRAN;

      UPDATE [dbo].[bookReview]
      SET
        [deleted] = 1,
        [dateModified] = GETUTCDATE()
      WHERE [idBook] = @idBook
        AND [idAccount] = @idAccount;

      /**
       * @output {ReviewDeleted, 1, 1}
       * @column {BIT} success
       */
      SELECT 1 AS [success];

    COMMIT TRAN;
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
    THROW;
  END CATCH;
END;
GO

/**
 * @summary
 * Updates reading progress
 * 
 * @procedure spReadingProgressUpdate
 * @schema dbo
 * @type stored-procedure
 * 
 * @parameters
 * @param {INT} idAccount - Account identifier
 * @param {INT} idBook - Book identifier
 * @param {INT} pagesRead - Pages read count
 */
CREATE OR ALTER PROCEDURE [dbo].[spReadingProgressUpdate]
  @idAccount INTEGER,
  @idBook INTEGER,
  @pagesRead INTEGER
AS
BEGIN
  SET NOCOUNT ON;

  DECLARE @shelf INTEGER;
  DECLARE @totalPages INTEGER;
  DECLARE @percentComplete NUMERIC(5, 2);

  /**
   * @validation Book exists and is in 'Lendo' shelf
   * @throw {bookNotFound}
   * @throw {bookMustBeInReadingShelf}
   */
  SELECT @shelf = [shelf], @totalPages = [totalPages]
  FROM [dbo].[book]
  WHERE [idBook] = @idBook
    AND [idAccount] = @idAccount
    AND [deleted] = 0;

  IF @shelf IS NULL
  BEGIN
    ;THROW 51000, 'bookNotFound', 1;
  END;

  IF @shelf <> 1
  BEGIN
    ;THROW 51000, 'bookMustBeInReadingShelf', 1;
  END;

  /**
   * @validation Pages read validation
   * @throw {pagesReadNegative}
   * @throw {pagesReadExceedsTotal}
   */
  IF @pagesRead < 0
  BEGIN
    ;THROW 51000, 'pagesReadNegative', 1;
  END;

  IF @totalPages IS NOT NULL AND @pagesRead > @totalPages
  BEGIN
    ;THROW 51000, 'pagesReadExceedsTotal', 1;
  END;

  /**
   * @rule {fn-reading-progress} Calculate percent complete
   */
  IF @totalPages IS NOT NULL AND @totalPages > 0
  BEGIN
    SET @percentComplete = (CAST(@pagesRead AS NUMERIC(10, 2)) / CAST(@totalPages AS NUMERIC(10, 2))) * 100;
  END
  ELSE
  BEGIN
    SET @percentComplete = 0;
  END;

  BEGIN TRY
    BEGIN TRAN;

      UPDATE [dbo].[readingProgress]
      SET
        [pagesRead] = @pagesRead,
        [percentComplete] = @percentComplete,
        [dateLastUpdate] = GETUTCDATE(),
        [dateModified] = GETUTCDATE()
      WHERE [idBook] = @idBook
        AND [idAccount] = @idAccount
        AND [deleted] = 0;

      /**
       * @output {ProgressUpdated, 1, 1}
       * @column {BIT} success
       * @column {NUMERIC(5,2)} percentComplete
       */
      SELECT 1 AS [success], @percentComplete AS [percentComplete];

    COMMIT TRAN;
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
    THROW;
  END CATCH;
END;
GO

/**
 * @summary
 * Gets or creates annual reading goal
 * 
 * @procedure spAnnualGoalGet
 * @schema dbo
 * @type stored-procedure
 * 
 * @parameters
 * @param {INT} idAccount - Account identifier
 * @param {INT} idUser - User identifier
 * @param {INT} year - Target year
 */
CREATE OR ALTER PROCEDURE [dbo].[spAnnualGoalGet]
  @idAccount INTEGER,
  @idUser INTEGER,
  @year INTEGER
AS
BEGIN
  SET NOCOUNT ON;

  DECLARE @idAnnualGoal INTEGER;

  SELECT @idAnnualGoal = [idAnnualGoal]
  FROM [dbo].[annualGoal]
  WHERE [idAccount] = @idAccount
    AND [idUser] = @idUser
    AND [year] = @year
    AND [deleted] = 0;

  IF @idAnnualGoal IS NULL
  BEGIN
    INSERT INTO [dbo].[annualGoal] (
      [idAccount],
      [idUser],
      [year],
      [targetBooks]
    )
    VALUES (
      @idAccount,
      @idUser,
      @year,
      12
    );

    SET @idAnnualGoal = SCOPE_IDENTITY();
  END;

  /**
   * @output {AnnualGoal, 1, n}
   * @column {INT} idAnnualGoal
   * @column {INT} year
   * @column {INT} targetBooks
   * @column {INT} booksRead
   * @column {NUMERIC(5,2)} percentComplete
   */
  SELECT
    [idAnnualGoal],
    [year],
    [targetBooks],
    [booksRead],
    [percentComplete]
  FROM [dbo].[annualGoal]
  WHERE [idAnnualGoal] = @idAnnualGoal;
END;
GO

/**
 * @summary
 * Updates annual reading goal
 * 
 * @procedure spAnnualGoalUpdate
 * @schema dbo
 * @type stored-procedure
 * 
 * @parameters
 * @param {INT} idAccount - Account identifier
 * @param {INT} idUser - User identifier
 * @param {INT} year - Target year
 * @param {INT} targetBooks - Target number of books
 */
CREATE OR ALTER PROCEDURE [dbo].[spAnnualGoalUpdate]
  @idAccount INTEGER,
  @idUser INTEGER,
  @year INTEGER,
  @targetBooks INTEGER
AS
BEGIN
  SET NOCOUNT ON;

  /**
   * @validation Target books range
   * @throw {targetBooksInvalid}
   */
  IF @targetBooks <= 0 OR @targetBooks > 1000
  BEGIN
    ;THROW 51000, 'targetBooksInvalid', 1;
  END;

  DECLARE @idAnnualGoal INTEGER;
  DECLARE @booksRead INTEGER;
  DECLARE @percentComplete NUMERIC(5, 2);

  SELECT @idAnnualGoal = [idAnnualGoal], @booksRead = [booksRead]
  FROM [dbo].[annualGoal]
  WHERE [idAccount] = @idAccount
    AND [idUser] = @idUser
    AND [year] = @year
    AND [deleted] = 0;

  SET @percentComplete = (CAST(@booksRead AS NUMERIC(10, 2)) / CAST(@targetBooks AS NUMERIC(10, 2))) * 100;

  BEGIN TRY
    BEGIN TRAN;

      IF @idAnnualGoal IS NULL
      BEGIN
        INSERT INTO [dbo].[annualGoal] (
          [idAccount],
          [idUser],
          [year],
          [targetBooks],
          [percentComplete]
        )
        VALUES (
          @idAccount,
          @idUser,
          @year,
          @targetBooks,
          @percentComplete
        );

        SET @idAnnualGoal = SCOPE_IDENTITY();
      END
      ELSE
      BEGIN
        UPDATE [dbo].[annualGoal]
        SET
          [targetBooks] = @targetBooks,
          [percentComplete] = @percentComplete,
          [dateModified] = GETUTCDATE()
        WHERE [idAnnualGoal] = @idAnnualGoal;
      END;

      /**
       * @output {GoalUpdated, 1, 1}
       * @column {INT} idAnnualGoal
       */
      SELECT @idAnnualGoal AS [idAnnualGoal];

    COMMIT TRAN;
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
    THROW;
  END CATCH;
END;
GO

/**
 * @summary
 * Gets dashboard statistics
 * 
 * @procedure spDashboardStatisticsGet
 * @schema dbo
 * @type stored-procedure
 * 
 * @parameters
 * @param {INT} idAccount - Account identifier
 * @param {INT} idUser - User identifier
 * @param {INT} year - Target year
 */
CREATE OR ALTER PROCEDURE [dbo].[spDashboardStatisticsGet]
  @idAccount INTEGER,
  @idUser INTEGER,
  @year INTEGER
AS
BEGIN
  SET NOCOUNT ON;

  /**
   * @output {AnnualGoal, 1, n}
   * @column {INT} targetBooks
   * @column {INT} booksRead
   * @column {NUMERIC(5,2)} percentComplete
   */
  SELECT
    [targetBooks],
    [booksRead],
    [percentComplete]
  FROM [dbo].[annualGoal]
  WHERE [idAccount] = @idAccount
    AND [idUser] = @idUser
    AND [year] = @year
    AND [deleted] = 0;

  /**
   * @output {MonthlyStats, n, n}
   * @column {INT} month
   * @column {INT} booksCompleted
   */
  SELECT
    MONTH([rdgPrg].[dateCompleted]) AS [month],
    COUNT(*) AS [booksCompleted]
  FROM [dbo].[readingProgress] [rdgPrg]
    JOIN [dbo].[book] [bk] ON ([bk].[idAccount] = [rdgPrg].[idAccount] AND [bk].[idBook] = [rdgPrg].[idBook])
  WHERE [rdgPrg].[idAccount] = @idAccount
    AND [bk].[idUser] = @idUser
    AND [rdgPrg].[dateCompleted] IS NOT NULL
    AND YEAR([rdgPrg].[dateCompleted]) = @year
    AND [rdgPrg].[deleted] = 0
    AND [bk].[deleted] = 0
  GROUP BY MONTH([rdgPrg].[dateCompleted])
  ORDER BY MONTH([rdgPrg].[dateCompleted]);

  /**
   * @output {GenreStats, n, n}
   * @column {NVARCHAR(50)} genre
   * @column {INT} bookCount
   */
  SELECT
    [bk].[genre],
    COUNT(*) AS [bookCount]
  FROM [dbo].[book] [bk]
  WHERE [bk].[idAccount] = @idAccount
    AND [bk].[idUser] = @idUser
    AND [bk].[shelf] = 2
    AND [bk].[genre] IS NOT NULL
    AND [bk].[deleted] = 0
  GROUP BY [bk].[genre]
  ORDER BY COUNT(*) DESC;

  /**
   * @output {TotalPages, 1, 1}
   * @column {INT} totalPagesRead
   */
  SELECT
    ISNULL(SUM([bk].[totalPages]), 0) AS [totalPagesRead]
  FROM [dbo].[book] [bk]
    JOIN [dbo].[readingProgress] [rdgPrg] ON ([rdgPrg].[idAccount] = [bk].[idAccount] AND [rdgPrg].[idBook] = [bk].[idBook])
  WHERE [bk].[idAccount] = @idAccount
    AND [bk].[idUser] = @idUser
    AND [rdgPrg].[dateCompleted] IS NOT NULL
    AND YEAR([rdgPrg].[dateCompleted]) = @year
    AND [bk].[deleted] = 0
    AND [rdgPrg].[deleted] = 0;
END;
GO