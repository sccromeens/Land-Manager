export type Role = "admin" | "chief" | "landman" | "client";

export const roleLabels: Record<Role, string> = {
  admin: "Admin",
  chief: "Chief",
  landman: "Landman",
  client: "Client",
};
