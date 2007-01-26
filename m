From: "Eric Van Hensbergen" <ericvh@gmail.com>
Subject: Re: [RFC][PATCH] dm-cow: copy-on-write stackable target
	for device-mapper
Date: Fri, 26 Jan 2007 11:07:28 -0600
Message-ID: <a4e6962a0701260907j786215adl9b4dbf1927c0195f@mail.gmail.com>
References: <200611271659.kARGx5qb017564@hera.kernel.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200611271659.kARGx5qb017564@hera.kernel.org>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Eric Van Hensbergen <ericvh@hera.kernel.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, paurea@gmail.com
List-Id: dm-devel.ids

On 11/27/06, Eric Van Hensbergen <ericvh@hera.kernel.org> wrote:
> Subject: [RFC] [PATCH] dm-cow: copy-on-write stackable target for device-mapper
>
> +
> +A simple script file is included to format WB.
> +The way it works is the standard dmsetup calls for
> +the device mapper. The arguments are
> +

There have been several requests for the "simple" script file.
Portions of its implementation are somewhat specific to our
installation (like the use of the rc shell).  I'm including it inline
here - not sure where else to put it -- perhaps in the Documentation:

#!/usr/bin/rc

tableboth ='0 devblksz cow devread 0 devwrite devbmapw 0'
devsize = `{sfdisk -s $1}

fn wipeoutdev{
        bmapsize = `{echo $devsize / 512 /2 |bc}
        echo dd 'if=/dev/zero' 'of='^$1 'count='^$bmapsize 'bs=512'
        dd 'if=/dev/zero' 'of='^$1 'count='^$bmapsize 'bs=512'
}

fn escapedev{
    echo $1|sed 's/\//\\\//g'
}


fn setcow{
        devread = `{escapedev $1}
        devwrite = `{escapedev $2}
        devbmapw = `{escapedev $3}
        tableset = `{echo $tableboth|sed -r 's/devread/'^$devread^'/'}
        tableset = `{echo $tableset|sed -r 's/devwrite/'^$devwrite^'/'}
        tableset = `{echo $tableset|sed -r 's/devbmapw/'^$devbmapw^'/'}
        devblksz = `{expr $devsize '*' 2}
        tableset = `{echo $tableset|sed -r 's/devblksz/'^$devblksz^'/'}
        echo trying to set $tableset
        echo $tableset > /tmp/tableset
        echo trying to dmsetup create $4
        dmsetup create $4 << EOF
$tableset
EOF
        dmsetup table
}

if(! ~ $#* 4){
        echo usage: newcow origdev destdev bmapdest namecow
        exit 1
}

namecow=$4
origdev=$1
wipeoutdev $2
setcow $1 $2 $3 $namecow
