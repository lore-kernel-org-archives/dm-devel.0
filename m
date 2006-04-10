From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: HSG80, DM, multipath issues
Date: Mon, 10 Apr 2006 20:28:47 +0200
Message-ID: <443AA3DF.3080404@free.fr>
References: <20060410174210.GA3798@tditx.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20060410174210.GA3798@tditx.com>
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


>
>   a. (the big one!) Is there something I'm doing wrong, or a workaround, or something that would
>      help me get this up & running
>   
You mostly got it right.

HP indeed is not interested in providing a firmware with LUN size 
inquiry enabled for this array. So we are bound to  ugly workarounds.

The one I used is "force a bounce per LUN just after driver loading", 
which this snippet does :

# cat read_ghost_capa
dummy_capa=2097152

for i in $(grep -rl $dummy_capa /sys/block/sd*/size|awk -F/ '{print $4}')
do
        sg_start -s 1 /dev/$i
        sleep 1
        echo 1>/sys/block/$i/device/rescan
done


The multipath tools are rightly refusing to deal with paths with unknown 
size. This won't change.

That problem solved, you'll hit the next wall, which is the hardware 
handler need for this array family.

Regards,
cvaroqui
