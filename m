From: "James Fillman" <JFillman@cucbc.com>
Subject: RE: Device-mapper-multipath RDAC
Date: Mon, 24 Sep 2007 10:01:15 -0700
Message-ID: <66F461DD7EDEEF4AA928FCC80B425B52AFCBEE@c2kp01mail.cucbc.com>
References: <200709241706.26322.npf-mlists@eurotux.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
content-class: urn:content-classes:message
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

I've just finished going through the process of getting our SAN gear
working on RHEL5 with multipathing. I've got a Sun 6140 which I think is
very similar to yours. They both are from ingenia. You'll want to use a
*NON* AVT host type on the SAN.  I've set mine to type "Linux" and it
works great.

cheers,
--james

-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On Behalf Of Nuno Fernandes
Sent: Monday, September 24, 2007 9:06 AM
To: device-mapper development
Subject: [dm-devel] Device-mapper-multipath RDAC

hello,

Just a question:

With recent support for rdac hardware handler in kernel 2.6.23-rc7, what

configuration should be in storage DS4700? AVT (Automatic Volume
transfer)=20
turned on or off?

When it's turned on, luns keep on jumping from controller to
controller..

Thanks
Nuno Fernandes

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
