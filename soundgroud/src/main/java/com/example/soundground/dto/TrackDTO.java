package com.example.soundground.dto;

import com.example.soundground.constants.TrackStatus;
import lombok.Data;

import java.util.Date;

@Data
public class TrackDTO {
    private Long trackId;
    private String title;
    private Date uploadDate;
    private String artwork;
    private String genre;
    private Long playsCount;
    private String audioPath;
    private TrackStatus status;
    private Long userId;

}
