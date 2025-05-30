require 'json'
BOOKS_FILE="books.json"
class Book
    attr_accessor :title, :auther, :isbn
    def initialize(isbn,title,auther,library)
        @title=title
        @auther=auther
        @isbn=isbn
        @library=library
        #create hash 
        book={"ISBN"=> @isbn,"title"=>@title,"author"=>@auther,"count"=>0}

        #read file 
        books_file=File.new(@library,"r")
        book_arr=JSON.load books_file
        books_file.close
        
        #append book to library
        book_arr << book

        #write to file
        books_file=File.new(@library,"w")
        json_book=JSON.generate(book_arr)
        books_file.syswrite(json_book)
        books_file.close
    end
end
class Book_Invetory
    def book_list(library)
        books_file=File.new(library,"r") 
        lib=JSON.load books_file
        lib.each do |book|
          puts "Book info: ISBN:#{book["ISBN"]}\tTitle:#{book["title"]}\tAuthor: #{book["author"]}"
        end
        books_file.close
    end
    def book_remove(isbn,library)
        #read file 
        books_file=File.new(library,"r")
        book_arr=JSON.load books_file
        books_file.close
        
        #iterate to remove
        book_arr.map do |book|
          if book["ISBN"]==isbn
            book_arr.delete(book)
          end
        end
        
        #rewrite
        books_file=File.new(library,"w")
        json_book=JSON.generate(book_arr)
        books_file.syswrite(json_book)
        books_file.close

    end
    def boo_sort library
        #read file 
        books_file=File.new(library,"r")
        book_arr=JSON.load books_file
        books_file.close

        #sort
        

        #rewrite

    end
end

# books_file=File.new("books.txt","a")
# books_file.syswrite("\nNada")
# books_file.close
# books_file=File.new("books.txt","r")
# puts (books_file.sysread(21))
# books_file.close
# book =Book.new "abc456","Essay","Mahmoud",BOOKS_FILE
# lib=Book_Invetory.new
# lib.book_remove "abc456",BOOKS_FILE
# lib.book_list BOOKS_FILE
# until choice == 0 
#     puts "1-Add Book\n2-Remove book by ISBN\n3-List all books"
#     choice=gets.chomp.to_i

    
# end 
while true
puts "1-Add Book\n2-Remove book by ISBN\n3-List all books"
choice=gets.chomp
case choice.to_i
when 0
    puts 'C U ")'
    break

when 1
    puts "ISBN: "
    isbn=gets.chomp
    puts "title: "
    title=gets.chomp
    puts "author: "
    author=gets.chomp
    book =Book.new isbn,title,author,BOOKS_FILE
when 2
    lib=Book_Invetory.new
    puts "ISBN: "
    isbn=gets.chomp
    lib.book_remove isbn, BOOKS_FILE

when 3
    lib=Book_Invetory.new
    lib.book_list BOOKS_FILE

end
    
end