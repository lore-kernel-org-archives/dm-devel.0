From: "Kevin Foote" <kevin.foote@gmail.com>
Subject: setting up a device section
Date: Thu, 8 Jun 2006 12:14:13 -0400
Message-ID: <5fb0f77b0606080914wd84141eg7e572f0657a5845e@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0190362419=="
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

--===============0190362419==
Content-Type: multipart/alternative;
	boundary="----=_Part_19849_12676766.1149783253698"

------=_Part_19849_12676766.1149783253698
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

All

Ive been working on setting up our multipath environment over the past few
weeks.
I have things working with multipath / failover as they should. Im trying
now to setup an
actual device section (using our defined hardware) within the
multipath.conffile. Previouisly
I just went with the default setup and things worked however, Im wondering
if I can get more
fine tuned with setting up an actual device section.

Am I thinking about this correctly? WIll this give me a better setup in the
future. and if so
are there docs on what HW I can create a device section for? Our current
setup is using an
equallogic psXXX iSCSI device for storage I have only seen reference to
NetApp and HP stuff
will others play nicely? And if this is not documented what entries within
the device section do
I need to get stuff rolling?

Thanks for any help. This dm-multipath stuff is cool :-) I love being able
to power off a switch
and still see the disk access work.

-- 
:wq!
kevin.foote

------=_Part_19849_12676766.1149783253698
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

All <br>
<br>
Ive been working on setting up our multipath environment over the past few weeks.<br>
I have things working with multipath / failover as they should. Im trying now to setup an <br>
actual device section (using our defined hardware) within the multipath.conf file. Previouisly <br>
I just went with the default setup and things worked however, Im wondering if I can get more <br>
fine tuned with setting up an actual device section. <br>
<br>
Am I thinking about this correctly? WIll this give me a better setup in the future. and if so <br>
are there docs on what HW I can create a device section for? Our current setup is using an <br>
equallogic psXXX iSCSI device for storage I have only seen reference to NetApp and HP stuff <br>
will others play nicely? And if this is not documented what entries within the device section do <br>
I need to get stuff rolling?<br><br clear="all">Thanks for any help. This dm-multipath stuff is cool :-) I love being able to power off a switch <br>
and still see the disk access work. <br>
<br>-- <br>:wq!<br>kevin.foote

------=_Part_19849_12676766.1149783253698--


--===============0190362419==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0190362419==--
