From: Thomas Deutschmann <whissi@gentoo.org>
Subject: Re: [PATCH] multipath-tools: Makefile: Respect standard
 toolchain related envvars
Date: Fri, 12 Jan 2018 00:26:29 +0100
Message-ID: <bb9b8db3-5a40-99f6-258b-1d0b81a25da7@gentoo.org>
References: <20171129232311.95483-1-whissi@gentoo.org>
	<1515709465.18410.6.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1515709465.18410.6.camel@suse.com>
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
To: Martin Wilck <mwilck@suse.com>, dm-devel@redhat.com
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

On 2018-01-11 23:24, Martin Wilck wrote:
> I'm not sure what you mean with "standard envvars" here. Is it "CFLAGS"
> and "LDFLAGS"? If that's what you mean, I disagree. 

Yes, I was especially talking about CFLAGS.


> CFLAGS handling is correct this way - CFLAGS should represent the final
> list of options passed to the compiler. Typically the Makefile
> assembles this list from internal project settings and user input.
> 
> Currently, setting OPTFLAGS is the preferred way to customize
> multipath-tools build.

And this works for you with the current multipath-tools package? Sorry,
maybe I am missing something but from my understanding the Makefile is
currently setting OPTFLAGS via

  OPTFLAGS = -O2 -g ....

So any OPTFLAGS value you are currently passing should be ignored at the
moment. That's why Bart and I independently from each other created this
patch.


> If changes are needed, I'd prefer Bart's suggestion.

Like said, Bart's variant works for me, too. We can pick his patch.


-- 
Regards,
Thomas Deutschmann / Gentoo Linux Developer
C4DD 695F A713 8F24 2AA1 5638 5849 7EE5 1D5D 74A5
