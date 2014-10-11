From: Mike Snitzer <snitzer@gmail.com>
Subject: Re: Subject: [PATCH] dm stripe: fixed resource leak of sc
Date: Fri, 10 Oct 2014 22:11:22 -0400
Message-ID: <CAMM=eLfqHJiiAgPwirgaB4DWY-D4-5TAWthrD9b0Mj0KKs6ipQ@mail.gmail.com>
References: <157461d0595944edb529638bf9ea3ec2@bgmail102.nvidia.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <157461d0595944edb529638bf9ea3ec2@bgmail102.nvidia.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: "agk@redhat.com" <agk@redhat.com>
List-Id: dm-devel.ids

On Fri, Oct 10, 2014 at 11:19 AM, Pavitra Kumar <pavitrak@nvidia.com> wrote:
> Fixed the resource leak of sc in case the chunk size
>
> exceeds the limit at dm_set_target_max_io_len.
>

I've staged this in linux-next, see:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=a3f2af2547884e02f7e43f995a6c442a4e54f1ea

But I changed the header to reflect that this leak isn't possible at this point.
BTW, your patch had mangled whitespace, so I applied the change by hand.

<snip>

>
> ________________________________
> This email message is for the sole use of the intended recipient(s) and may
> contain confidential information.  Any unauthorized review, use, disclosure
> or distribution is prohibited.  If you are not the intended recipient,
> please contact the sender by reply email and destroy all copies of the
> original message.
> ________________________________

Please try to get rid of boilerplate corporate footers like this in
your mails if you're posting to a public mailing list with the intent
of allowing _everyone_ to consume your change.
