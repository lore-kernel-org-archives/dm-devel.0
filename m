From: Akira Hayakawa <ruby.wktk@gmail.com>
Subject: Re: dm-flakey NOT to return -EIO on READ?
Date: Sat, 30 Jul 2016 09:26:43 +0900
Message-ID: <c3b3b1bd-c4f6-adf3-c4d1-bea038c19e5c@gmail.com>
References: <217a0cf8-4853-6316-3016-77460073061d@gmail.com>
	<CAM4Jq_5kBs2WKNOiLrVL8XMTSJQhPdvO-XKROhzpLXdOATFw7w@mail.gmail.com>
	<07b6affb-a09d-7d55-65f8-6d476a5471aa@gmail.com>
	<f059f3f1-a860-aee5-20b7-d6b3ed6b467d@gmail.com>
	<CAM4Jq_7WWFsviFXeAYa5gd_wrL73Fuz0goXbzG7Q-dYujkh1ag@mail.gmail.com>
	<0dc69d8f-1595-1677-5028-f920d7b54eb0@gmail.com>
	<CAM4Jq_4+RuRppTQXDBkp7Kg4tRV52pwcfEfm5HZtC88h0v-aWw@mail.gmail.com>
	<20160729143542.GA19246@redhat.com> <20160729173012.GA88908@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160729173012.GA88908@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Lukas Herbolt <lherbolt@redhat.com>
List-Id: dm-devel.ids

Mike,

> This fix should resolve the problem, I'll be staging it to go upstream
> during the 4.8-rc cycle (Akira, please test to verify your test fails as
> expected now):

I tested with the patch and it's now ok.

Akira

On 2016/07/30 2:30, Mike Snitzer wrote:
> On Fri, Jul 29 2016 at 10:35am -0400,
> Mike Snitzer <snitzer@redhat.com> wrote:
> 
>> On Fri, Jul 29 2016 at 10:31am -0400,
>> Lukas Herbolt <lherbolt@redhat.com> wrote:
>>
>>>  - http://people.redhat.com/~lherbolt/dm-flakey/v4.7-dm_flakey.tar.gz
>>>
>>> Lukas
>>
>> Please post an incremental patch relative to 4.7 or latest Linus
>> kernel.  Don't make people suffer with tarballs of whatever you've
>> packaged above.
> 
> I pulled out your incremental diff.  Your proposed fix isn't correct.  It
> breaks the corrupt_bio_byte feature.  We cannot blindly drop reads early
> in flakey_map(), like you've proposed, because the corrupt_bio_byte
> feature relies on corrupt data being returned on read during the
> down_interval.
> 
> The issue reported is: reads aren't dropped during the "down_interval".
> 
> I do agree that this needs fixing, and it was commit a3998799fb4df ("dm
> flakey: add corrupt_bio_byte feature") that caused this regression.
> 
> But a fix must not break the corrupt_bio_byte feature.
> 
> This fix should resolve the problem, I'll be staging it to go upstream
> during the 4.8-rc cycle (Akira, please test to verify your test fails as
> expected now):
> 
> From: Mike Snitzer <snitzer@redhat.com>
> Date: Fri, 29 Jul 2016 13:19:55 -0400
> Subject: [PATCH] dm flakey: error READ bios during the down_interval
> 
> When the corrupt_bio_byte feature was introduced it caused READ bios to
> no longer be errored with -EIO during the down_interval.  This had to do
> with the complexity of needing to submit READs if the corrupt_bio_byte
> feature was used.
> 
> Fix it so READ bios are properly errored with -EIO; doing so early in
> flakey_map() as long as there isn't a match for the corrupt_bio_byte
> feature.
> 
> Fixes: a3998799fb4df ("dm flakey: add corrupt_bio_byte feature")
> Reported-by: Akira Hayakawa <ruby.wktk@gmail.com>
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/md/dm-flakey.c | 23 +++++++++++++++--------
>  1 file changed, 15 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
> index 29b99fb..19db13e 100644
> --- a/drivers/md/dm-flakey.c
> +++ b/drivers/md/dm-flakey.c
> @@ -289,10 +289,16 @@ static int flakey_map(struct dm_target *ti, struct bio *bio)
>  		pb->bio_submitted = true;
>  
>  		/*
> -		 * Map reads as normal.
> +		 * Map reads as normal only if corrupt_bio_byte set.
>  		 */
> -		if (bio_data_dir(bio) == READ)
> -			goto map_bio;
> +		if (bio_data_dir(bio) == READ) {
> +			/* If flags were specified, only corrupt those that match. */
> +			if (fc->corrupt_bio_byte && (fc->corrupt_bio_rw == READ) &&
> +			    all_corrupt_bio_flags_match(bio, fc))
> +				goto map_bio;
> +			else
> +				return -EIO;
> +		}
>  
>  		/*
>  		 * Drop writes?
> @@ -330,12 +336,13 @@ static int flakey_end_io(struct dm_target *ti, struct bio *bio, int error)
>  
>  	/*
>  	 * Corrupt successful READs while in down state.
> -	 * If flags were specified, only corrupt those that match.
>  	 */
> -	if (fc->corrupt_bio_byte && !error && pb->bio_submitted &&
> -	    (bio_data_dir(bio) == READ) && (fc->corrupt_bio_rw == READ) &&
> -	    all_corrupt_bio_flags_match(bio, fc))
> -		corrupt_bio_data(bio, fc);
> +	if (!error && pb->bio_submitted && (bio_data_dir(bio) == READ)) {
> +		if (fc->corrupt_bio_byte)
> +			corrupt_bio_data(bio, fc);
> +		else
> +			return -EIO;
> +	}
>  
>  	return error;
>  }
> 
