class RankTextConverter {
  static String format(int? rank){
    if(rank == null) {
      return "-";
    }
    if(rank <= 0) {
      return "-";
    }
    if(rank == 1) {
      return "1 st";
    }
    if(rank == 2) {
      return "2 nd";
    }
    if(rank == 3) {
      return "3 rd";
    }
    return "$rank th";
  }
}
