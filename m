From: Brian Long <brilong@cisco.com>
Subject: Re: Clariion CX600 automatic failback support
Date: Mon, 31 Oct 2005 10:51:38 -0500
Message-ID: <1130773899.4071.18.camel@brilong-lnx>
References: <013350FE9CC8AC4EB602045723F47222B9A2BB@xmb-rtp-215.amer.cisco.com>
	<1130767086.4071.6.camel@brilong-lnx> <20051031140712.GA31532@free.fr>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20051031140712.GA31532@free.fr>
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

On Mon, 2005-10-31 at 15:07 +0100, Christophe Varoqui wrote:
> > 
> > No one has automatic failback working on Clarrion storage?
> > 
> Do you reproduce with upstream ?

No.  I imagine we will log a support request with Red Hat to get it
working on RHEL 4 U2.  If they want to give us an updated device-mapper-
multipath RPM to try to reproduce with upstream, that's up to them.
Phil and I were just wondering if there is a specific configuration
parameter to get the trespass to happen again once all paths are back
online.

/Brian/

-- 
       Brian Long                      |         |           |
       IT Data Center Systems          |       .|||.       .|||.
       Cisco Linux Developer           |   ..:|||||||:...:|||||||:..
       Phone: (919) 392-7363           |   C i s c o   S y s t e m s
