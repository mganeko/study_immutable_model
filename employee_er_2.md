## 素朴な設計

```mermaid
erDiagram
Employee {
  string employee_number
  string name
  date birthday
  integer current_age
  date join_date
  integer length_of_service
  integer department_id
  string position
}

Department {
  integer id
  string name
}

Department ||--o{ Employee:"所属"

```

## 情報的な属性を除外

```mermaid
erDiagram
Employee {
  string employee_number
  string name
  date birthday
  date join_date
  integer department_id
  string position
}


Department {
  integer id
  string name
}

Department ||--o{ Employee:"所属"

```

## 配属イベントを導入

```mermaid
erDiagram
Employee {
  string employee_number
  string name
  date birthday
  date join_date
}

Assignment {
  integer department_id
  string employee_number
  string position
  date assign_date
}

Department {
  integer id
  string name
}

Department ||--o{ Assignment:"配属"
Employee ||--o{ Assignment:"配属"


```

## 配属と離任イベントを分割

```mermaid
erDiagram
Employee {
  string employee_number
  string name
  date birthday
  date join_date
}

Assignment {
  integer department_id
  string employee_number
  string position
  date assign_date
}

Leave {
  integer department_id
  string employee_number
  string position
  date leave_date
}

Department {
  integer id
  string name
}

Department ||--o{ Assignment:"配属"
Employee ||--o{ Assignment:"配属"

Department ||--o{ Leave:"離任"
Employee ||--o{ Leave:"離任"

```

## 情報をキャッシュ

```mermaid
erDiagram
Employee {
  string employee_number
  string name
  date birthday
  date join_date
  integer main_department_id
  string main_position
}

Assignment {
  integer department_id
  string employee_number
  string position
  date assign_date
}

Leave {
  integer department_id
  string employee_number
  string position
  date leave_date
}

Department {
  integer id
  string name
}

Department ||--o{ Assignment:"配属"
Employee ||--o{ Assignment:"配属"

Department ||--o{ Leave:"離任"
Employee ||--o{ Leave:"離任"

```
