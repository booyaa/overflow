// create 10 pseudo random numbers (between 0 and 20)
// source: http://stackoverflow.com/a/30835475/105282
var foo = Enumerable.Range(0, 20)
          .OrderBy(x => Guid.NewGuid().GetHashCode())
          .Distinct()
          .Take(10)
          .ToArray();

// print them
foo.ToList().ForEach(p => Console.Write($"\t{p}");
Console.WriteLine();
