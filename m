From: Teodor Milkov <tm@del.bg>
Subject: Re: dm-cache issue
Date: Fri, 2 Dec 2016 21:49:19 +0200
Message-ID: <8acf015f-89f4-4e47-ed5e-2f8e150e8039@del.bg>
References: <CAJV2nOTJoWWc=N80e6WCpZUh6ZRxvCW8Wt=aZWTyYSKso+kQ5Q@mail.gmail.com>
	<884adfe3-ac18-5e37-f4b4-478e5031f35f@redhat.com>
	<55289e1d-5a24-73a5-4ccf-026c2640334d@del.bg>
	<f01aaf8d-1f12-1a6f-5560-5cb6927a1b62@gmail.com>
	<9bab689e-edf4-c5a6-9954-75f0e9c3d2c6@del.bg>
	<36a1bed8-b979-35de-155f-e07daf707fac@gmail.com>
	<689d0d91-70c9-b864-0a9c-0c00af96008e@del.bg>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5613870478524148383=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <689d0d91-70c9-b864-0a9c-0c00af96008e@del.bg>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--===============5613870478524148383==
Content-Type: multipart/alternative;
	boundary="------------2725222B2254B4FD8D8F0B33"

This is a multi-part message in MIME format.
--------------2725222B2254B4FD8D8F0B33
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

So, I ended up with the following setup:

  * Modified /etc/init.d/lvm2 to explicitly deactivate logical volumes:
    /lvm lvchange -a n --select name=~.*/
      o Create////lvm2-clean-shutdown /if deactivation is successful.//
  * Turn off automatic LV activation by
    setting///auto_activation_volume_list=[]/ in //etc/lvm/lvm.conf/
  * Try to activate LVs later in the boot only
    if//////lvm2-clean-shutdown /exists.//

This way I have the chance to try manual activation of the volumes in 
the case of unclean shutdown, or eventually uncache and recreate caches 
if flush/refresh appears to take too much time.

One strange thing is that while testing I forgot to set 
/auto_activation_volume_list=[] /and//boot process got stuck at an very 
early stage – probably at udev activating lvm //(////sbin/lvm pvscan 
--cache --activate ay/ from //lib/udev/rules.d/69-lvm-metad.rules)./// I 
waited for about five minutes but it didn't look like it's going to 
finish anytime soon, and I had no tty (too early in the boot), so I did 
reboot with a rescue CD and turned off LV auto activation in lvm.conf. 
This time the system came up quickly and the odd thing is that manual 
/lvchange -ay/ was pretty fast - less that a minute for all 12 × 60GB 
caches. So, maybe there's a bug in /udev/pvscan --activate/?

Anyway, the above setup seems to work well for me, so I'm sticking with 
it for the time being.

Best regards,
Teodor


--------------2725222B2254B4FD8D8F0B33
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: 8bit

<html>
  <head>
    <meta content="text/html; charset=utf-8" http-equiv="Content-Type">
  </head>
  <body bgcolor="#FFFFFF" text="#000000">
    So, I ended up with the following setup:<br>
    <br>
    <ul>
      <li>Modified /etc/init.d/lvm2 to explicitly deactivate logical
        volumes: <em>lvm lvchange -a n --select name=~.*</em></li>
      <ul>
        <li>Create<em> </em><em>/lvm2-clean-shutdown </em>if
          deactivation is successful.<em></em></li>
      </ul>
      <li>Turn off automatic LV activation by setting<em> </em><em>auto_activation_volume_list=[]</em>
        in <em>/etc/lvm/lvm.conf</em></li>
      <li>Try to activate LVs later in the boot only if<em> </em><em></em><em>/lvm2-clean-shutdown
        </em>exists.<em></em></li>
    </ul>
    <p>This way I have the chance to try manual activation of the
      volumes in the case of unclean shutdown, or eventually uncache and
      recreate caches if flush/refresh appears to take too much time.</p>
    <p>One strange thing is that while testing I forgot to set <em>auto_activation_volume_list=[]
      </em>and<em> </em>boot process got stuck at an very early stage –
      probably at udev activating lvm <i><em>(</em></i><em>/sbin/lvm
        pvscan --cache --activate ay</em> from <em>/lib/udev/rules.d/69-lvm-metad.rules).</em><em></em>
      I waited for about five minutes but it didn't look like it's going
      to finish anytime soon, and I had no tty (too early in the boot),
      so I did reboot with a rescue CD and turned off LV auto activation
      in lvm.conf. This time the system came up quickly and the odd
      thing is that manual <i>lvchange -ay</i> was pretty fast - less
      that a minute for all 12 × 60GB caches. So, maybe there's a bug in
      <i>udev/pvscan --activate</i>?</p>
    <p>Anyway, the above setup seems to work well for me, so I'm
      sticking with it for the time being.</p>
    <p>Best regards,<br>
      Teodor<br>
    </p>
  </body>
</html>

--------------2725222B2254B4FD8D8F0B33--


--===============5613870478524148383==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5613870478524148383==--
