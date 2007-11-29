From: "Scott Moseman" <scmoseman@gmail.com>
Subject: Re: Multipath with 2 NICs?
Date: Thu, 29 Nov 2007 08:46:22 -0600
Message-ID: <342d47870711290646h7966427dh871228389c220fcb@mail.gmail.com>
References: <342d47870710250734g56732109v804904260f8d1808@mail.gmail.com>
	<4720DB3E.3090506@cs.wisc.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4720DB3E.3090506@cs.wisc.edu>
Content-Disposition: inline
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

To confirm, 5.1 will allow MPIO over 2 NICs w/o requiring an HBA?

Thanks,
Scott


On Oct 25, 2007 12:06 PM, Mike Christie <michaelc@cs.wisc.edu> wrote:
>
> > We're interesting in using multipath I/O from our Red Hat servers
> > with our iSCSI SAN in order to have failover in the event of a switch
> > failure.  Our vendor gave me a product matrix and it says we cannot
> > use 2 NICs under Red Hat, we must use 1 NIC and 1 HBA.  I'm not
> > finding any clear cut explanation of this in the device-mapper
> > documentation, unless I'm missing something.  Are we really required
> > to use an HBA instead of just 1 NICs with DM?
>
> In RHEL 5.0, that is true.
>
> In RHEL 5.1 you can now bind a session to a specific nic and multipath
> over the two sessions. See sectrion 5.1 in
> /usr/share/doc/iscsi-initiator-utils-*/README for info on how to do this.
>
