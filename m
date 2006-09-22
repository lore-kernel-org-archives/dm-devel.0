From: Edward Goggin <egoggin@emc.com>
Subject: Why is device mapper unable to remove a mapped device
	which is open?
Date: Fri, 22 Sep 2006 16:26:16 -0400
Message-ID: <6CCEAEDF4D06984A83F427424F47D6E4013D13D9@CORPUSMX40A.corp.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
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

It seems very un-posix like to not be able to remove a=20
dm mapped device file even when the mapped device is open.

Why shouldn't the kernel's reference counting for the
mapped device's md structure account for properly=20
handling the de-allocation of the md structure upon
the last close in this case?
