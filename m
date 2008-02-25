From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.24.2: 4KSTACKS + pcdrw + dm + mount -> stack
 overflow: ide-cd related? dm-related?
Date: Mon, 25 Feb 2008 14:51:56 -0800
Message-ID: <20080225145156.4184b509.akpm@linux-foundation.org>
References: <87wsovkth5.fsf@hades.wkstn.nix> <87skzipcpw.fsf@hades.wkstn.nix>
	<m363wepa3a.fsf@telia.com> <87oda6p9st.fsf@hades.wkstn.nix>
	<20080225123041.401da103.akpm@linux-foundation.org>
	<20080225224807.GA15700@atrey.karlin.mff.cuni.cz>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080225224807.GA15700@atrey.karlin.mff.cuni.cz>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jan Kara <jack@suse.cz>
Cc: Nix <nix@esperi.org.uk>, Peter Osterlund <petero2@telia.com>, dm-devel@redhat.com, Jan Kara <jack@ucw.cz>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Mon, 25 Feb 2008 23:48:07 +0100 Jan Kara <jack@suse.cz> wrote:

> > udf_process_sequence() seems to be another victim of gcc inlining.
>   Hmm, I'll have a look what we can do.

noinline...

> > udf_add_entry() defines a couple of 256-byte local arrays.
>   Yes, exactly two of them. One is  non-trivial to get rid of - it's
> used for encoding of filename before we write it, but one is used during
> scanning of the directory whether the entry doesn't already exists (oh,
> my!) and we can just rip that off..

kmalloc is quite fast ;)
