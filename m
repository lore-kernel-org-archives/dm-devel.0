From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: [RFC] disk doesn't spin down with thin pool +
	dmeventd
Date: Fri, 8 Jan 2016 09:17:20 +0100
Message-ID: <568F7090.4030908@redhat.com>
References: <568EBD08.70800@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <568EBD08.70800@gmail.com>
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
List-Id: dm-devel.ids

Dne 7.1.2016 v 20:31 Alan Jenkins napsal(a):
> Hi
>
> I tried using Docker on my Fedora NAS box.  It created a thin pool LV, which
> caused hard drive activity every ~10 seconds.
>
> dmeventd queries the thin pool every 10 seconds, and it causes a transaction
> commit in order to make sure the statistics are up to date. But transactions
> are already supposed to be committed after 1 second. (See
> Documentation/device-mapper/thin-provisioning.txt, "Updating on-disk metadata").
>
> It seems like a simple case of "don't do that".  The kernel already lets us
> avoid the commit.  How about it (patch below)?  If it seems reasonable, I can
> whip up a commit message for it.
>

Hi

I believe it's already solved upstream in version 2.02.133
of lvm2 package with this commit:

81e9ab3156badecc6a64447708c4ae4886e3c244
Date: Thu Oct 22 12:36:25 2015 +0200

Which version of lvm2 are you using ?

Regards

Zdenek
