From: Thanos Makatos <thanos.makatos@onapp.com>
Subject: Re: [PATCH] thin_dump: added --device-id, --skip-mappings,
 and new output --format's
Date: Tue, 15 Mar 2016 10:59:15 +0000
Message-ID: <CAM2wQBvGUs=Co=b89Nw_TYN_qBfCZj-6S7sHdinDNHPm_ZS1PA@mail.gmail.com>
References: <alpine.LRH.2.11.1603150104370.19675@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.11.1603150104370.19675@mail.ewheeler.net>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Eric Wheeler <dm-devel@lists.ewheeler.net>
Cc: device-mapper development <dm-devel@redhat.com>, Joe Thornber <thornber@redhat.com>
List-Id: dm-devel.ids

On 15 March 2016 at 01:45, Eric Wheeler <dm-devel@lists.ewheeler.net> wrote:
> Hi Joe,
>
> Please review the patch below when you have a moment.  I am interested in
> your feedback, and also interested in having this functionality merged
> upstream.  This was written against thin-provisioning-tools.git tag
> v0.5.6.
>
> We use thin_dump on live dm-thin metadata snapshots all the time.  In our
> case, we want to dump the XML for new (snapshot) volumes instead of
> dumping the entire 16gb metadata device (37.8% used) which takes ~20-30
> minutes instead of ~5 seconds for a single volume with --device-id.

I'm interested in extracting the mappings of a particular device, too.
In fact, I've implemented this (along with extracting the mappings in
binary format) and have only recently opened a PR:
https://github.com/jthornber/thin-provisioning-tools/pull/49. It seems
that we've replicated some work here, I'm not sure whether we're
supposed to send patches to this list or open PR on github.
