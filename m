From: Marius Bakke <marius@devup.no>
Subject: Re: [PATCH] multipath-tools: Fix compiler warnings when
	built without systemd.
Date: Wed, 17 Jun 2020 01:17:57 +0200
Message-ID: <87d05yeh22.fsf@gnu.org>
References: <20200516175508.12412-1-marius@devup.no>
	<d909fc0a2383f028ae7c3ad00c142193ca8d9ae7.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <d909fc0a2383f028ae7c3ad00c142193ca8d9ae7.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>, dm-devel@redhat.com
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Martin Wilck <mwilck@suse.com> writes:

> Hello Marius,
>
> On Sat, 2020-05-16 at 19:55 +0200, Marius Bakke wrote:
>> ---
>>  libmultipath/config.c |  2 +-
>>  multipathd/main.c     | 19 +++++++++++++------
>>  2 files changed, 14 insertions(+), 7 deletions(-)
>> 
>
> thank you for the patch, and sorry for the late reply.
> Thanks to Xose, too, for making me aware of it.
>
> This patch needs some improvements, see remarks below.
>
> In general, please note that the development and in particular the
> testing of multipath-tools has been done almost exclusively on systems
> using systemd for several years now. The compilation issues you
> encountered may only be the tip of the iceberg. In particular, the udev
> rules shipped with multipath-tools rely on systemd for proper device
> setup.

Thanks for reviewing.  I'm mainly here for 'kpartx' anyway, but "good"
to know that multipath-tools may need extra care outside of systemd.

I'm hardly a C programmer, so thanks for bearing with me.  Adding just
plain old ifdef guards is much clearer than sprinkling __attribute__
around.

V2 sent in a separate message.

Thanks,
Marius
