// =============================================================================
// KFPS Hengsten Platform — Database Types
// Generated manually from supabase/migrations/20240120000000_initial_schema.sql
//
// Regenerate automatically (when Supabase CLI is configured):
//   supabase gen types typescript --linked > types/database.ts
// =============================================================================

export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

// ── Score types ───────────────────────────────────────────────────────────────
export type ScoreType = 'exterieur' | 'sport' | 'gebruiksaanleg' | 'lineair'
export type ScoreSource = 'kfps' | 'eigen_meting' | 'keuring'
export type UserRole = 'user' | 'admin'

// ── Predicate values ──────────────────────────────────────────────────────────
export type Predicate =
  | 'ster'
  | 'kroon'
  | 'model'
  | 'preferent'
  | 'elite'
  | 'prestatie'
  | 'sport'

// =============================================================================
// DATABASE INTERFACE (matches Supabase client gen format)
// =============================================================================
export interface Database {
  public: {
    Tables: {
      profiles: {
        Row: {
          id: string
          full_name: string | null
          stable_name: string | null
          location: string | null
          phone: string | null
          role: UserRole
          created_at: string
          updated_at: string
        }
        Insert: {
          id: string
          full_name?: string | null
          stable_name?: string | null
          location?: string | null
          phone?: string | null
          role?: UserRole
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          full_name?: string | null
          stable_name?: string | null
          location?: string | null
          phone?: string | null
          role?: UserRole
          updated_at?: string
        }
      }

      mares: {
        Row: {
          id: string
          user_id: string
          name: string
          stamboeknummer: string | null
          birth_year: number | null
          color: string | null
          height_cm: number | null
          sire_name: string | null
          dam_name: string | null
          damsire_name: string | null
          predicates: string[]
          photo_url: string | null
          notes: string | null
          kfps_data: Json
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          user_id: string
          name: string
          stamboeknummer?: string | null
          birth_year?: number | null
          color?: string | null
          height_cm?: number | null
          sire_name?: string | null
          dam_name?: string | null
          damsire_name?: string | null
          predicates?: string[]
          photo_url?: string | null
          notes?: string | null
          kfps_data?: Json
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          user_id?: string
          name?: string
          stamboeknummer?: string | null
          birth_year?: number | null
          color?: string | null
          height_cm?: number | null
          sire_name?: string | null
          dam_name?: string | null
          damsire_name?: string | null
          predicates?: string[]
          photo_url?: string | null
          notes?: string | null
          kfps_data?: Json
          updated_at?: string
        }
      }

      mare_scores: {
        Row: {
          id: string
          mare_id: string
          score_type: ScoreType
          category: string
          value: number
          source: ScoreSource
          measured_at: string | null
          created_at: string
        }
        Insert: {
          id?: string
          mare_id: string
          score_type: ScoreType
          category: string
          value: number
          source?: ScoreSource
          measured_at?: string | null
          created_at?: string
        }
        Update: {
          id?: string
          mare_id?: string
          score_type?: ScoreType
          category?: string
          value?: number
          source?: ScoreSource
          measured_at?: string | null
        }
      }

      stallions: {
        Row: {
          id: string
          name: string
          stamboeknummer: string | null
          birth_year: number | null
          color: string | null
          height_cm: number | null
          sire_name: string | null
          dam_name: string | null
          damsire_name: string | null
          predicates: string[]
          photo_url: string | null
          stud_fee: number | null
          owner_name: string | null
          owner_contact: string | null
          available: boolean
          kfps_data: Json
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          name: string
          stamboeknummer?: string | null
          birth_year?: number | null
          color?: string | null
          height_cm?: number | null
          sire_name?: string | null
          dam_name?: string | null
          damsire_name?: string | null
          predicates?: string[]
          photo_url?: string | null
          stud_fee?: number | null
          owner_name?: string | null
          owner_contact?: string | null
          available?: boolean
          kfps_data?: Json
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          name?: string
          stamboeknummer?: string | null
          birth_year?: number | null
          color?: string | null
          height_cm?: number | null
          sire_name?: string | null
          dam_name?: string | null
          damsire_name?: string | null
          predicates?: string[]
          photo_url?: string | null
          stud_fee?: number | null
          owner_name?: string | null
          owner_contact?: string | null
          available?: boolean
          kfps_data?: Json
          updated_at?: string
        }
      }

      stallion_scores: {
        Row: {
          id: string
          stallion_id: string
          score_type: ScoreType
          category: string
          value: number
          source: ScoreSource
          measured_at: string | null
          created_at: string
        }
        Insert: {
          id?: string
          stallion_id: string
          score_type: ScoreType
          category: string
          value: number
          source?: ScoreSource
          measured_at?: string | null
          created_at?: string
        }
        Update: {
          id?: string
          stallion_id?: string
          score_type?: ScoreType
          category?: string
          value?: number
          source?: ScoreSource
          measured_at?: string | null
        }
      }
    }

    Views: {
      [_ in never]: never
    }

    Functions: {
      [_ in never]: never
    }

    Enums: {
      [_ in never]: never
    }
  }
}

// =============================================================================
// CONVENIENCE TYPES
// Shorter aliases for use throughout the app.
// =============================================================================

export type Profile        = Database['public']['Tables']['profiles']['Row']
export type ProfileInsert  = Database['public']['Tables']['profiles']['Insert']
export type ProfileUpdate  = Database['public']['Tables']['profiles']['Update']

export type Mare           = Database['public']['Tables']['mares']['Row']
export type MareInsert     = Database['public']['Tables']['mares']['Insert']
export type MareUpdate     = Database['public']['Tables']['mares']['Update']

export type MareScore      = Database['public']['Tables']['mare_scores']['Row']
export type MareScoreInsert = Database['public']['Tables']['mare_scores']['Insert']

export type Stallion       = Database['public']['Tables']['stallions']['Row']
export type StallionInsert = Database['public']['Tables']['stallions']['Insert']
export type StallionUpdate = Database['public']['Tables']['stallions']['Update']

export type StallionScore      = Database['public']['Tables']['stallion_scores']['Row']
export type StallionScoreInsert = Database['public']['Tables']['stallion_scores']['Insert']

// =============================================================================
// EXTENDED / JOINED TYPES
// Handy types for joined queries (selecteer merrie mét haar scores, etc.)
// =============================================================================

export type MareWithScores = Mare & {
  mare_scores: MareScore[]
}

export type StallionWithScores = Stallion & {
  stallion_scores: StallionScore[]
}

// Grouped scores per type — handy for the detail page score tabs
export type ScoresByType = {
  exterieur:     MareScore[] | StallionScore[]
  sport:         MareScore[] | StallionScore[]
  gebruiksaanleg: MareScore[] | StallionScore[]
  lineair:       MareScore[] | StallionScore[]
}
