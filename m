From: "Peter Koutoupis" <Peter_Koutoupis@us.xyratex.com>
Subject: multipath features
Date: Wed, 25 Oct 2006 13:17:01 -0700
Message-ID: <1121230D3E3B6B4E9162069832D90A64292861@XYUS-EX22.xyus.xyratex.com>
References: <453F0902.6030902@Voltaire.COM>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <453F0902.6030902@Voltaire.COM>
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

I cannot seem to find an answer for this no matter where I look, but if
I wanted to queue all IO if there was no path for a LIMITED time before
it eventually times out, does a feature exist?  Currently I am using "1
queue_if_no_path" but the last thing I want is for a path to be
unavailable and have it consume all host resources until the host cannot
handle it anymore.  Thanks in advance.

Regards,

Peter Koutoupis
Systems Engineer
Xyratex International, Inc.
1804 Centre Point Circle
Suite 112
Naperville, IL 60563 USA
(630)364-7656
