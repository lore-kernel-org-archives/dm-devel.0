From: Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.24.2: 4KSTACKS + pcdrw + dm + mount -> stack
	overflow: ide-cd related? dm-related?
Date: Tue, 26 Feb 2008 12:29:32 +0100
Message-ID: <20080226112932.GB10996@elte.hu>
References: <87wsovkth5.fsf@hades.wkstn.nix> <87skzipcpw.fsf@hades.wkstn.nix>
	<m363wepa3a.fsf@telia.com> <87oda6p9st.fsf@hades.wkstn.nix>
	<20080225123041.401da103.akpm@linux-foundation.org>
	<20080225224807.GA15700@atrey.karlin.mff.cuni.cz>
	<Pine.LNX.4.64.0802261207140.30955@jikos.suse.cz>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802261207140.30955@jikos.suse.cz>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jiri Kosina <jkosina@suse.cz>
Cc: Jan Kara <jack@ucw.cz>, Jan Kara <jack@suse.cz>, Peter Osterlund <petero2@telia.com>, linux-kernel@vger.kernel.org, Nix <nix@esperi.org.uk>, dm-devel@redhat.com, Andrew Morton <akpm@linux-foundation.org>
List-Id: dm-devel.ids


* Jiri Kosina <jkosina@suse.cz> wrote:

> +	name = kmalloc(sizeof(char) * UDF_NAME_LEN, GFP_KERNEL);
> +	fname = kmalloc(sizeof(char) * UDF_NAME_LEN, GFP_KERNEL);
> +
> +	if (!name || !fname) {
> +		*err = -ENOMEM;
> +		return NULL;
> +	}
> +
>  	if (dentry) {
>  		if (!dentry->d_name.len) {
>  			*err = -EINVAL;

this bit is missing i think:

	if (name)
		kfree(name);
	if (fname)
		kfree(fname);

	Ingo
