From: Jim Lester <Jim.Lester@compellent.com>
Subject: Custom priority callout
Date: Wed, 13 Aug 2008 09:32:27 -0500
Message-ID: <A7519D7FDEF2A144BA6D40BDF13100FEF14CB5@ex2.Beer.Town>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Class: urn:content-classes:message
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

I know that the issue with writing custom priority callouts is that they
need to be running in RAM so that if the disk is lost, it can be called
again.=20

My question is, if I write a custom binary file, and statically compile
it so it doesn't link against any libraries, does multipath
automatically load it into RAM because it mentioned in the config file,
or is their other code that has to be modified to load it.=20

Thanks.

---
Jim Lester | Linux Product Specialist
Jim.Lester@Compellent.com
(o) 952.294.2802
(c) 763.218.6012
Compellent Technologies | www.compellent.com
