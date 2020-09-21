From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 13/19] libmultipath: provide defaults for
 {get, put}_multipath_config
Date: Mon, 21 Sep 2020 21:42:20 +0200
Message-ID: <791d9ff29703d66d31669dedb233d082724bf2fd.camel@suse.com>
References: <20200916153718.582-1-mwilck@suse.com>
	<20200916153718.582-14-mwilck@suse.com>
	<20200921190859.GX11108@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200921190859.GX11108@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, 2020-09-21 at 14:08 -0500, Benjamin Marzinski wrote:
> 
> free_config() doesn't actually work for configs that are initialized
> by
> init_config(). That's fine, but the commit message is wrong. Also, I
> wonder if uninit_config() should zero out __internal_config, so that
> it's in the same state as it was before init_config() is called.

argh, did it that way first, then changed my mind, and forgot to fix
the commit message .... sorry. Good point about zeroing it out.

Martin
