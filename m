From: "Maupin, Chase" <Chase.Maupin@hp.com>
Subject: FW: [Bug 7763] kernel panic on writing to
	dm-crypt->cciss partition
Date: Fri, 5 Jan 2007 10:50:13 -0600
Message-ID: <54D33DF96D82FC4799283C875B243853035486CF@cceexc13.americas.cpqcorp.net>
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
Cc: "Miller, Mike (OS Dev)" <mike.miller@hp.com>
List-Id: dm-devel.ids

I am forwarding this e-mail to let you know about a bugzilla that was
filled involving the dm-crypt driver and cciss.  From my testing and the
debug I have put into the kernel it seems that when the dm-crypt driver
is sitting on top of the  cciss driver it is not adhering to our scatter
gather element limitation of 31.  I see that the bio that is created and
turned into a request by the dm-crypt driver can contain 64 sg elements
which causes us to throw a bug in our request routine.

I noticed that the comments in crypt_alloc_buffer say not to violate the
device limitations but I did not see any code that actually checks those
limitations.  In other dm modules I noticed code such a __split_bio
which seemed to be breaking up bio's based on the limitations of the
lower level.

Could you please have someone join this bugzilla and look into this
issue?

I have attached the debug output from the serial console on my system to
the issue.  Please let me know what I can do to help.=20


Thank You,
Chase Maupin
HP Linux Storage Drivers
Houston, TX=20
-----Original Message-----
From: bugme-daemon@bugzilla.kernel.org
[mailto:bugme-daemon@bugzilla.kernel.org]=20
Sent: Friday, January 05, 2007 10:42 AM
To: Maupin, Chase
Subject: [Bug 7763] kernel panic on writing to dm-crypt->cciss partition

http://bugzilla.kernel.org/show_bug.cgi?id=3D7763





------- Additional Comments From chase.maupin@hp.com  2007-01-05 08:35
------- Hermann,

I have found that the dm-crypt module is violating our queue limitations
for the number of scatter gather elements we can handle per request.  I
have captured this in the debug output I have attached to this issue.  I
am going to work with the RedHat dm development to get this resolved as
this issue does not seem to be present in other dm modules.  I have seen
some code in these other modules such as __split_bio which seems to
break up the data based on the low level device limitations as reported
by the driver.

The crypt function crypt_alloc_buffer says in the comments that it
should not violate these limits, but I did not find code to verify that
this is true.  I found that in the crypt_alloc_buffer function we are
seeing bio structures with more than 31 segments which later get sent to
the cciss driver as requests. =20

I will send this bugzilla to the RedHat dm mailing list so that they can
keep it up to date.  Thanks for your help on this.

Chase

------- You are receiving this mail because: ------- You are the
assignee for the bug, or are watching the assignee.
