From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH 2/2] dm-crypt: Add TCW IV mode for old CBC
	TCRYPT containers.
Date: Mon, 28 Oct 2013 17:58:35 +0100
Message-ID: <526E97BB.2080604@gmail.com>
References: <1382275000-10660-1-git-send-email-gmazyland@gmail.com>
	<1382275000-10660-2-git-send-email-gmazyland@gmail.com>
	<20131028160849.GB25212@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20131028160849.GB25212@redhat.com>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On 28.10.2013 17:08, Mike Snitzer wrote:
> What does TCW mean?  How does it relate to CBC?
> - Is TCW mode: "CBC mode with some additional tweaks"?

Yes, as said in previous mail, it is just shortcut.

>
>> While TCRYPT CBC mode is legacy and is known to be vulnerable
>> to some watermarking attacks (e.g. revealing of hidden disk
>> existence) it can be still useful to mount old containers
>> without using 3rd party software or for independent forensic
>> analysis of such containers.
>
> Now you're switching back to referring to "TCRYPT CBC mode".  What
> happened to "TCW mode"?

I am talking about implementation in general, not dmcrypt specific one.
It is still the same mode of course.

>> There is also second key used for "whitening" of sectors.
>> Whitening key is xored with sector number and mixed using
>> CRC32 and resulting value is applied to whole sector.
>> (Detailed calculation is in Truecrypt documentation for version < 4.1
>> and will be also described on dmcrypt site.)
>
> Can you add a pointer to the Truecrypt documentation for < 4.1?

I am afraid they removed all old documentation from site.
(but search google e.g. for truecrypt-3.1a-user-guide.pdf or
some similar version which use CBC mode, whitening and IV
generator is described there as well)

>  Or a pointer to the dmcrypt site documentation?

Description is not yet there (once it is in kernel I will add it)
but link is referenced even from kernel Documentation
http://code.google.com/p/cryptsetup/wiki/DMCrypt

(and yes, seems that IV generators need better description there)

Thanks,
Milan
