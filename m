From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: Clariion CX600 automatic failback support
Date: Mon, 31 Oct 2005 17:06:52 +0100
Message-ID: <20051031160652.GB31532@free.fr>
References: <013350FE9CC8AC4EB602045723F47222B9A2BB@xmb-rtp-215.amer.cisco.com>
	<1130767086.4071.6.camel@brilong-lnx>
	<20051031140712.GA31532@free.fr>
	<1130773899.4071.18.camel@brilong-lnx>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1130773899.4071.18.camel@brilong-lnx>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

On Mon, Oct 31, 2005 at 10:51:38AM -0500, Brian Long wrote:
> On Mon, 2005-10-31 at 15:07 +0100, Christophe Varoqui wrote:
> > > 
> > > No one has automatic failback working on Clarrion storage?
> > > 
> > Do you reproduce with upstream ?
> 
> No.  I imagine we will log a support request with Red Hat to get it
> working on RHEL 4 U2.  If they want to give us an updated device-mapper-
> multipath RPM to try to reproduce with upstream, that's up to them.
> Phil and I were just wondering if there is a specific configuration
> parameter to get the trespass to happen again once all paths are back
> online.
> 
Every check interval, the daemon re-evaluates path priorities (through
external prioritizers), then re-compute path-groups priorities. If PG
priority order change, the highest-prio PG might be activated :

- immediatly, if "failback" is set to immediate
- never, if "failback" is set to manual
- in a number of prio-order stable consecutive checks, if failback
  set to #

Thus, failback/no-failback is a property of the external prioritizer, plus
a framework policy switch in the name of the "failback" config file keyword.

Well, at least it is the current design upstream.
You'll have to dig the changelog to see if RedHat packages all the
necassary bits.

Regards,
cvaroqui
