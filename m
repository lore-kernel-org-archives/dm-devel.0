From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: open-iscsi + dm-multipath
Date: Tue, 22 Mar 2005 16:13:09 +0100
Message-ID: <20050322151309.GB17219@averon.dyndns.org>
References: <1110657791.16560.11.camel@mylaptop>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1110657791.16560.11.camel@mylaptop>
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

On Sat, Mar 12, 2005 at 12:03:11PM -0800, Dmitry Yusupov wrote:
> Hi Guys!
> 
> had anyone tried to setup open-iscsi with dm-multipath yet?
> I think it should work out of the box, but would be cool if someone will
> double check on that.
> 
> PS: www.open-iscsi.org is a new cool project which features some
> noticeable performance improvements for soft-based iSCSI Initiator plus
> other number of exciting abilities such as independent transport and
> better user-space vs. kernel split. Read more on project's web page.
> 
Hello,

Does your log.[ch] implementation works around syslog blocking behaviour in memory contention situation ?
If so, I would like to fetch it in multipath-tools, with your agreement.
Also, if you have better ideas on the subject, I'm interested in reading them :)

Regards,
cvaroqui
