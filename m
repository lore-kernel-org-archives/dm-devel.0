From: "Jeff McCune" <JMcCune@ntst.com>
Subject: RE: multipath-tools Patch Submission -
	mpath_prop_classcallout
Date: Thu, 6 Nov 2008 15:49:44 -0500
Message-ID: <9A7F9F83A843AD4EBDE53D0D868ECD42034BA51F@NTST-OH-MAIL01.ntst.com>
References: <9A7F9F83A843AD4EBDE53D0D868ECD4203471F24@NTST-OH-MAIL01.ntst.com>
	<20081106204750.GA14092@linux.vnet.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <20081106204750.GA14092@linux.vnet.ibm.com>
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
Cc: cristophe.varoqui@free.fr
List-Id: dm-devel.ids


> > I receive the following error when I attempt to clone it:
> >
> > [jmccune@homer dev]$ git clone
> > http://kernel.org/pub/scm/linux/storage/multipath-tools/
> > Initialized empty Git repository in
> > /asp/home/jmccune/dev/multipath-tools/.git/
> > Cannot get remote repository information.
> > Perhaps git-update-server-info needs to be run there?
>=20
> Can you try the git url?
>=20
> git clone git://git.kernel.org/pub/scm/linux/storage/multipath-
> tools/.git

That works like a charm.  Thanks, I'll patch and publish the repository
shortly.


Cheers,
--
Jeff McCune
Senior System Administrator
Netsmart Technologies
1-800-434-2642 x7382





This message is intended only for the use of the individual or entity=20
to which it is addressed, and may contain information that is=20
privileged, confidential and exempt from disclosure under applicable=20
law. If the reader of this message is not the intended recipient, or=20
the employer or agent responsible for delivering the message to the=20
intended recipient, you are hereby notified that any dissemination,=20
distribution or copying of this communication is strictly prohibited.=20
If you have received this communication in error, please notify the=20
sender immediately by telephone and delete the material from your=20
computer. Thank you for your cooperation.
