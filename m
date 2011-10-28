From: Milan Broz <mbroz@redhat.com>
Subject: Re: Mapping sectors to have errors
Date: Fri, 28 Oct 2011 21:42:22 +0200
Message-ID: <4EAB059E.3050900@redhat.com>
References: <4EAA13E4.6020709@cs.utah.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4EAA13E4.6020709@cs.utah.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Yathindra <ydev@cs.utah.edu>
List-Id: dm-devel.ids

On 10/28/2011 04:31 AM, Yathindra wrote:
> I'm trying to create a disk and map some sectors to have errors on them.
> 
> I tried this,
> echo "0 100000 linear /dev/sdb 0 100000 480081250 error"| dmsetup create bad_disk
> device-mapper: reload ioctl failed: Invalid argument
> Command failed

Try
echo -e "0 100000 linear /dev/sdb 0\n100000 480081250 error"| dmsetup create bad_disk

Milan
