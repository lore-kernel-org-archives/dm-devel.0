From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: multipath-0.5.0 still provides broken udev rules
Date: Mon, 25 Apr 2016 12:58:26 +0200
Message-ID: <571DF852.6030604@redhat.com>
References: <CAE+k_g+Eh3H1EAiJ0jm7P-efGbOOwpWRtYmvXyR9qhhHtefV7g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAE+k_g+Eh3H1EAiJ0jm7P-efGbOOwpWRtYmvXyR9qhhHtefV7g@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Peter Volkov <peter.volkov@gmail.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On 25.4.2016 12:52, Peter Volkov wrote:
> Hi, guys.
>
> There is a problem: udev does not create partitions for multipath devices in
> case I use kpartx.rules provided with multipath sources. I found that udev
> always go to kpartx_end after following line of rules:
> ENV{DM_TABLE_STATE}!="LIVE", GOTO="kpartx_end"

Hi

Just curious - what would you want to do with inactive table???
You cannot read/scan such device ?



>
> There is 8 (!!!) years old thread that discusses this problem:
> https://www.redhat.com/archives/dm-devel/2007-July/msg00095.html
>
> So what is the current state? Should we fix udev rules for multipath or should
> we create better patch for dmsetup.c? Meanwhile I've copied multipath.rules
> from redhat and partitions are created as they should.


What is the exact problem you do have/see ?

Can you describe in some single repeatable steps a reproducer ?

Which distro are you talking about  (Fedora ? Debian ??)

Have you opened any bugzilla anywhere ?


Regard

Zdenek
