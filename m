From: andysayshi <andysayshi@gmail.com>
Subject: run multipath at boot?
Date: Thu, 9 Mar 2006 12:06:19 -0500
Message-ID: <3f57d11c0603090906w1718c2c3uf1cbbafa6dc8ce9c@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0806699027=="
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

--===============0806699027==
Content-Type: multipart/alternative;
	boundary="----=_Part_9413_9991520.1141923979755"

------=_Part_9413_9991520.1141923979755
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

hey,

multipath v0.4.5
RHEL ES4 U2
2.6.9-22

we have dm-mulitpath setup and everything works fine. noticing tho, that
upon bootup, devices aren't created. (/dev/mapper doesnt have the alises).
we would have to run 'multipath' then 'mount -a' to mount up the devices.

i've been looking on line to see how to have the system take care of this
during boot up so that once it's finished booting up, it'll scan so that
those mounts will be there automatically.

there were mentions that it's taken care of in /etc/rc.sysinit, and i see
entries in there for multipath, so im not sure why its not working.

any ideas? lemme know if you need more info.

from rc.sysinit:

# LVM2 initialization
if [ -x /sbin/lvm.static -o -x /sbin/multipath -o -x /sbin/dmraid ]; then
    if ! LC_ALL=3DC fgrep -q "device-mapper" /proc/devices 2>/dev/null ; th=
en
        modprobe dm-mod >/dev/null 2>&1
    fi
    echo "mkdmnod" | /sbin/nash --quiet >/dev/null 2>&1
    [ -n "$SELINUX" ] && restorecon /dev/mapper/control >/dev/null 2>&1
fi

if [ -c /dev/mapper/control ]; then
    if [ -f /etc/multipath.conf -a -x /sbin/multipath ]; then
        modprobe dm-multipath >/dev/null 2>&1
        /sbin/multipath -v 0
    fi

    if [ -x /sbin/dmraid ]; then
        modprobe dm-mirror > /dev/null 2>&1
        /sbin/dmraid -i -a y
    fi

    if [ -x /sbin/lvm.static ]; then
        if /sbin/lvm.static vgscan --mknodes --ignorelockingfailure >
/dev/null 2>&1 ; then
            action $"Setting up Logical Volume Management:" /sbin/lvm.stati=
c
vgchange -a y --ignorelock
ingfailure
        fi
    fi
fi


# chkconfig --list multipathd
multipathd      0:off   1:off   2:on    3:on    4:on    5:on    6:off


thanks.

andy

------=_Part_9413_9991520.1141923979755
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

hey,<br>
<br>
multipath v0.4.5<br>
RHEL ES4 U2<br>
2.6.9-22<br>
<br>
we have dm-mulitpath setup and everything works fine. noticing tho,
that upon bootup, devices aren't created. (/dev/mapper doesnt have the
alises). we would have to run 'multipath' then 'mount -a' to mount up
the devices.<br>
<br>
i've been looking on line to see how to have the system take care of
this during boot up so that once it's finished booting up, it'll scan
so that those mounts will be there automatically.<br>
<br>
there were mentions that it's taken care of in /etc/rc.sysinit, and i
see entries in there for multipath, so im not sure why its not working.<br>
<br>
any ideas? lemme know if you need more info.<br>
<br>
from rc.sysinit:<br>
<br>
# LVM2 initialization<br>
if [ -x /sbin/lvm.static -o -x /sbin/multipath -o -x /sbin/dmraid ]; then<b=
r>
&nbsp;&nbsp;&nbsp; if ! LC_ALL=3DC fgrep -q &quot;device-mapper&quot; /proc=
/devices 2&gt;/dev/null ; then<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; modprobe dm-mod &gt;/dev/null 2&=
gt;&amp;1<br>
&nbsp;&nbsp;&nbsp; fi<br>
&nbsp;&nbsp;&nbsp; echo &quot;mkdmnod&quot; | /sbin/nash --quiet &gt;/dev/n=
ull 2&gt;&amp;1<br>
&nbsp;&nbsp;&nbsp; [ -n &quot;$SELINUX&quot; ] &amp;&amp; restorecon /dev/m=
apper/control &gt;/dev/null 2&gt;&amp;1<br>
fi<br>
<br>
if [ -c /dev/mapper/control ]; then<br>
&nbsp;&nbsp;&nbsp; if [ -f /etc/multipath.conf -a -x /sbin/multipath ]; the=
n<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; modprobe dm-multipath &gt;/dev/n=
ull 2&gt;&amp;1<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /sbin/multipath -v 0<br>
&nbsp;&nbsp;&nbsp; fi<br>
<br>
&nbsp;&nbsp;&nbsp; if [ -x /sbin/dmraid ]; then<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; modprobe dm-mirror &gt; /dev/nul=
l 2&gt;&amp;1<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /sbin/dmraid -i -a y<br>
&nbsp;&nbsp;&nbsp; fi<br>
&nbsp;&nbsp;&nbsp; <br>
&nbsp;&nbsp;&nbsp; if [ -x /sbin/lvm.static ]; then<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if /sbin/lvm.static vgscan
--mknodes --ignorelockingfailure &gt; /dev/null 2&gt;&amp;1 ; then<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
action $&quot;Setting up Logical Volume Management:&quot; /sbin/lvm.static
vgchange -a y --ignorelock<br>
ingfailure<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; fi<br>
&nbsp;&nbsp;&nbsp; fi<br>
fi<br>
<br>
<br>
# chkconfig --list multipathd<br>
multipathd&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0:off&nbsp;&nbsp;
1:off&nbsp;&nbsp; 2:on&nbsp;&nbsp;&nbsp; 3:on&nbsp;&nbsp;&nbsp;
4:on&nbsp;&nbsp;&nbsp; 5:on&nbsp;&nbsp;&nbsp; 6:off<br>
<br>
<br>
thanks.<br>
<br>
andy<br>
<br>

------=_Part_9413_9991520.1141923979755--


--===============0806699027==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0806699027==--
