From: "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Subject: Re: [PATCH 1/2] md/raid0: Introduce new array state
 'broken' for raid0
Date: Thu, 1 Aug 2019 09:07:28 -0300
Message-ID: <037ef0ef-1a34-f522-6b31-e388906a87fa@canonical.com>
References: <20190729203135.12934-1-gpiccoli@canonical.com>
	<20190729203135.12934-2-gpiccoli@canonical.com>
	<CAPhsuW5n9TCZjVT3QnFhHkbfPTvh7ifFiNXypOHouL5ByZS7+w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAPhsuW5n9TCZjVT3QnFhHkbfPTvh7ifFiNXypOHouL5ByZS7+w@mail.gmail.com>
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
To: Song Liu <liu.song.a23@gmail.com>
Cc: linux-block@vger.kernel.org, Song Liu <songliubraving@fb.com>, NeilBrown <neilb@suse.com>, linux-raid <linux-raid@vger.kernel.org>, dm-devel@redhat.com, Jay Vosburgh <jay.vosburgh@canonical.com>
List-Id: dm-devel.ids

On 31/07/2019 16:43, Song Liu wrote:
>[...]
>> @@ -4315,6 +4329,7 @@ array_state_store(struct mddev *mddev, const char *buf, size_t len)
>>                 break;
>>         case write_pending:
>>         case active_idle:
>> +       case broken:
>>                 /* these cannot be set */
>>                 break;
>>         }
> 
> Maybe it is useful to set "broken" state? When user space found some issues
> with the drive?
> 
> Thanks,
> Song

Hi Song, thanks a lot for your feedback. I can easily add that in V2
along with Neil's suggestion, I agree with you.
There is a 2/2 patch regarding the mdadm counterpart; you should have
received the email, but for completeness, the link is:

lore.kernel.org/linux-block/20190729203135.12934-3-gpiccoli@canonical.com

Thanks,


Guilherme
