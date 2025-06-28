export interface AssociationData{
  title:string;
  content:string;
  footer:string;
}
export default class Association{
  title:string = "";
  content:string = "";
  footer:string = "";

  constructor(title:string,content:string,footer:string) {
    this.title=title;
    this.content=content;
    this.footer=footer;
  }
}

