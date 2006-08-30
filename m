From: David Wysochanski <davidw@netapp.com>
Subject: Re: Multipathd not starting up properly
Date: Wed, 30 Aug 2006 14:48:15 -0400
Message-ID: <44F5DD6F.4080208@netapp.com>
References: <608c44bf0608291112h1b62eef2hec5ceeb491e9b5b@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <608c44bf0608291112h1b62eef2hec5ceeb491e9b5b@mail.gmail.com>
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

Adam Huffman wrote:
> I'm seeing the following messages when I start multipathd:
> 
> Aug 29 19:00:21 multipathd: error calling out /sbin/scsi_id -g -u -s 
> /block/sda
> Aug 29 19:00:21 multipathd: error calling out /sbin/scsi_id -g -u -s 
> /block/sdb
> 

Does /sbin/scsi_id exist on your system?

Did you try running this manually from the command line?
