from __future__ import print_function    # (at top of module)
import pandas as pd
import json
import time
import sys
from tqdm import tqdm_notebook
import spotipy
from spotipy.oauth2 import SpotifyClientCredentials


#sp = spotipy.Spotify(auth_manager=SpotifyClientCredentials(client_id="56e8c847e9974517952ef0d040f2a78b",
                                                    #       client_secret="5622c0f1f94243ffa051cfbdf4734578"))
#getting the titles of an album by a band
#results = sp.search(q='abba', limit=20)
#for idx, track in enumerate(results['tracks']['items']):
 #   print(idx, track['name'])

## shows acoustic features for tracks for the given artist

client_credentials_manager = SpotifyClientCredentials(client_id="56e8c847e9974517952ef0d040f2a78b",
                                                       client_secret="5622c0f1f94243ffa051cfbdf4734578")
sp = spotipy.Spotify(client_credentials_manager=client_credentials_manager)

def df_tracks(tracklist):
    '''
    Takes the output of artist_tracks (i.e. a list of lists),
    puts it in a dataframe and formats it.
    '''

    df = pd.DataFrame(tracklist, columns=['artist',
                                          'album_name',
                                          'album_uri',
                                          'track',
                                          'release_date'] + list(sp.audio_features('7tr2za8SQg2CI8EDgrdtNl')[0].keys()))

    df.rename(columns={'uri': 'song_uri'}, inplace=True)

    df.drop_duplicates(subset=['artist', 'track', 'release_date'], inplace=True)

    # Reorder the cols to have identifiers first, auditory features last
    cols = ['artist', 'album_name', 'album_uri', 'track', 'release_date', 'id', 'song_uri', 'track_href',
            'analysis_url', 'type', 'danceability', 'energy', 'key', 'loudness', 'mode', 'speechiness',
            'acousticness', 'instrumentalness', 'liveness', 'valence', 'tempo', 'duration_ms', 'time_signature']

    df = df[cols]

    return df
