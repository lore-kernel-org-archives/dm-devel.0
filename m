From: Shyam Sundar <g.shyamsundar@yahoo.co.in>
Subject: Trying to register hw_handler for MSA 1000
Date: Wed, 10 May 2006 18:20:33 +0100 (BST)
Message-ID: <20060510172033.29880.qmail@web8514.mail.in.yahoo.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids


I am trying to get my MSA 1000 backend failover going.
As far as I understand, I will have to register a
hw_handler for that target, and have it registered to
the dm so that during the failover, it issues a
START_STOP command to the controller.

I have a SLES 10 10 system and have the dm-hp-sw
source and Makefile.

Q. How do I register the hw-handler so the START_STOP
is invoked.

Thanks
Shyam


	=09
__________________________________________________________=20
Yahoo! India Answers: Share what you know. Learn something new.=20
http://in.answers.yahoo.com
