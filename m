From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 13/21] libmultipath: provide defaults for
 {get, put}_multipath_config
Date: Fri, 25 Sep 2020 22:00:10 +0200
Message-ID: <e0637cd84ca36dbba00f8ff5b92ffcb8e81aa747.camel@suse.com>
References: <20200924133716.14120-1-mwilck@suse.com>
	<20200924133716.14120-14-mwilck@suse.com>
	<20200925043458.GO11108@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200925043458.GO11108@octiron.msp.redhat.com>
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

On Thu, 2020-09-24 at 23:34 -0500, Benjamin Marzinski wrote:
> 
> This causes problems with the libmpathvalid library code I
> wrote.  The
> issue is that right now, when you run _init_config() if
> get_multipath_config() returns NULL, you will use the default
> loglevel.
> I would like the library user to have control of the log level, even
> during the calls to _init_config().

I see. So using init_config() actually had a benefit for you already
over load_config() :-) Such control over the verbosity would actually
be good for multipath-tools, too.

> One possiblity would be to make init_config() take verbosity as an
> argument.  There would also need to be some other config variable
> that
> gets set at the start of init_config(), which is used by
> libmp_get_multipath_config() to check if it is initialized.

I suggest to track the verbosity independently in a different variable,
and just set it from init_config() if it was actually set in the
config file. Most of the time, we set it from the command line.
This would have the additional benefit not to have to call
get_multipath_config() in dlog().

Martin
