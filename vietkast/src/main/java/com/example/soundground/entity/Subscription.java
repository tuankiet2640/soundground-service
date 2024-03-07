package com.example.soundground.entity;

import jakarta.persistence.*;
import org.hibernate.validator.constraints.UUID;

@Entity
public class Subscription {

    @UUID
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    private User user;

    @ManyToOne
    private Show show;

}
