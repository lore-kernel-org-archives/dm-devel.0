From: Milan Broz <gmazyland@gmail.com>
Subject: Re: dm-crypt: support using encrypted keys
Date: Thu, 23 Apr 2020 16:41:20 +0200
Message-ID: <83f9aeb6-9400-1b8a-cb98-263ee1762cea@gmail.com>
References: <20200420134659.1640089-1-dbaryshkov@gmail.com>
	<20200421182754.GA49104@lobo>
	<e3b78a32-4307-c60c-f9c3-dd6d71b6633c@gmail.com>
	<20200422214052.GA10695@redhat.com>
	<67eedf43-7afb-3c2e-704a-d0ac187d6a4b@gmail.com>
	<20200423140612.GA14885@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200423140612.GA14885@redhat.com>
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
To: Mike Snitzer <snitzer@redhat.com>
Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>, Dmitry Baryshkov <dmitry_baryshkov@mentor.com>, David Howells <dhowells@redhat.com>, dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On 23/04/2020 16:06, Mike Snitzer wrote:
> 
> Seems you didn't look at the fixed patch, here is what I ultimately
> staged yesterday:
> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.8&id=a2b35bd064baf1f4e7504c23d493a3e149172dd1
> 
> dm-crypt doesn't have a hard dependency on CONFIG_ENCRYPTED_KEYS.  If it
> is enabled support will be available, if not enabled support isn't.

It is acceptable solution if you really want to push it now.
Just you will repeat the same #ifdef exercise for the "trusted" key type.

What we did last time, is here - it combines dynamic key type loading
and #if IS_REACHABLE(CONFIG_ENCRYPTED_KEYS) (we cannot avoid it if it is completely compiled out here)
It is somewhat more readable for me and eliminates few ifdefs.

Just it can be no longer applied, but the idea is here in two old patches:
  https://mbroz.fedorapeople.org/tmp/

Milan
