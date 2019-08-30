From: "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Subject: Re: [PATCH v3 2/2] mdadm: Introduce new array state
 'broken' for raid0/linear
Date: Fri, 30 Aug 2019 09:48:11 -0300
Message-ID: <1a215cee-cbbb-ec3a-937a-2bcfb8049fef@canonical.com>
References: <20190822161318.26236-1-gpiccoli@canonical.com>
	<20190822161318.26236-2-gpiccoli@canonical.com>
	<87a7brf4or.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <87a7brf4or.fsf@notabene.neil.brown.name>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: NeilBrown <neilb@suse.de>
Cc: Neil F Brown <nfbrown@suse.com>, Song Liu <songliubraving@fb.com>, jes.sorensen@gmail.com, liu.song.a23@gmail.com, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-block@vger.kernel.org, jay.vosburgh@canonical.com
List-Id: dm-devel.ids

Thanks Neil! CCing Jes, also comments inline:


On 30/08/2019 05:17, NeilBrown wrote:
>> [...]
>> +	char arrayst[12] = { 0 }; /* no state is >10 chars currently */
> 
> Why do you have an array?  Why not just a "char *".
> Then all the "strncpy" below become simple pointer assignment.

OK, makes sense! I'll try to change it.


>> [...]  
>>  int WaitClean(char *dev, int verbose)
>>  {
>> @@ -1116,7 +1120,8 @@ int WaitClean(char *dev, int verbose)
>>  			rv = read(state_fd, buf, sizeof(buf));
>>  			if (rv < 0)
>>  				break;
>> -			if (sysfs_match_word(buf, clean_states) <= 4)
> 
> Arg.  That is horrible.  Who wrote that code???
> Oh, it was me.  And only 8 years ago.

rofl, happens!


> sysfs_match_word() should return a clear "didn't match" indicator, like
> "-1".
> 
> Ideally that should be fixed, but I cannot really expect you to do that.
> 
> Maybe make it
>    if (clean_states[sysfs_match_word(buf, clean_states)] != NULL)
>  ??
> or
>    if (sysfs_match_word(buf, clean_states) < ARRAY_SIZE(clean_states)-1)
> 
> Otherwise the patch looks ok.

OK, thanks for the review! I'll try to change that in V4 too.
cheers,


Guilherme
