From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [mdadm PATCH] Fix typo in new udev rule.
Date: Fri, 5 May 2017 11:07:29 -0400
Message-ID: <02e0eacd-7d1c-5fd9-b94b-5d906f4fda5a@gmail.com>
References: <149265560315.31004.3851231165281498425.stgit@noble>
 <149265600601.31004.323865505557190368.stgit@noble>
 <dedd27cd-9c2e-f244-d8aa-7a074679d3c6@gmail.com>
 <87mvbasqx6.fsf@notabene.neil.brown.name>
 <40a5fbff-9eef-07b3-fe1b-fb9a888cfb8b@redhat.com>
 <87h919ruj5.fsf@notabene.neil.brown.name>
 <85c9e9e1-3d2c-9f88-e923-235fb69a4188@redhat.com>
 <87r303opcw.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87r303opcw.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, Peter Rajnoha <prajnoha@redhat.com>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On 05/05/2017 01:16 AM, NeilBrown wrote:
>
> As pointed out by Peter Rajnoha, the correct usage in udev is
> TEST=="file", not TEST="file".
>
> Also improve a related comment which was a bit informal.
>
> Reported-by: Peter Rajnoha <prajnoha@redhat.com>
> Fixes: cd6cbb08c458 ("Create: tell udev md device is not ready when first created.")
> Signed-off-by: NeilBrown <neilb@suse.com>
> ---
>
> Thanks Peter!  Properly tested as well :-)
>
> NeilBrown

Applied!

Thanks both of you!

Jes


