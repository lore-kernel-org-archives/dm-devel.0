From: "Scott Moseman" <scmoseman@gmail.com>
Subject: Multipath with 2 NICs?
Date: Thu, 25 Oct 2007 09:34:56 -0500
Message-ID: <342d47870710250734g56732109v804904260f8d1808@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

We're interesting in using multipath I/O from our Red Hat servers with
our iSCSI SAN in order to have failover in the event of a switch
failure.  Our vendor gave me a product matrix and it says we cannot
use 2 NICs under Red Hat, we must use 1 NIC and 1 HBA.  I'm not
finding any clear cut explanation of this in the device-mapper
documentation, unless I'm missing something.  Are we really required
to use an HBA instead of just 1 NICs with DM?

Thanks,
Scott
