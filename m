From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: Multipath with 2 NICs?
Date: Thu, 25 Oct 2007 13:06:54 -0500
Message-ID: <4720DB3E.3090506@cs.wisc.edu>
References: <342d47870710250734g56732109v804904260f8d1808@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <342d47870710250734g56732109v804904260f8d1808@mail.gmail.com>
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

Scott Moseman wrote:
> We're interesting in using multipath I/O from our Red Hat servers with
> our iSCSI SAN in order to have failover in the event of a switch
> failure.  Our vendor gave me a product matrix and it says we cannot
> use 2 NICs under Red Hat, we must use 1 NIC and 1 HBA.  I'm not
> finding any clear cut explanation of this in the device-mapper
> documentation, unless I'm missing something.  Are we really required
> to use an HBA instead of just 1 NICs with DM?
> 

In RHEL 5.0, that is true.

In RHEL 5.1 you can now bind a session to a specific nic and multipath 
over the two sessions. See sectrion 5.1 in 
/usr/share/doc/iscsi-initiator-utils-*/README for info on how to do this.
