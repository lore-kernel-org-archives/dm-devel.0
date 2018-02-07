From: Milan Broz <gmazyland@gmail.com>
Subject: Re: Help request: setting up /dev/zero using dm-crypt ...
Date: Wed, 7 Feb 2018 09:43:58 +0100
Message-ID: <129830fa-aa37-7de1-6670-76eeaed5a18d@gmail.com>
References: <CABRTiaiJNVk-UXOVq6Qhah3sLRrjj1sb6KVWHNnVP1JbMUzx1w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CABRTiaiJNVk-UXOVq6Qhah3sLRrjj1sb6KVWHNnVP1JbMUzx1w@mail.gmail.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ravi Prakash Putchala <praks.putchala@gmail.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On 02/07/2018 09:15 AM, Ravi Prakash Putchala wrote:
> We would like to experiment and see the performance results with different options of dm-crypt. To do this we would like to setup /dev/zero with dm-crypt as mentioned in https://www.redhat.com/archives/dm-devel/2015-February/msg00106.html
> However, when I did the following no new mapping gets created in /dev/mapper:
> 
> # cryptsetup -y luksFormat /dev/zero

This command cannot work, /dev/zero is a character device, moreover all writes there are discarded.

Seems cryptsetup does not print error message here (that is a bug) but return value of this command
indicates the problem: 4 - that means "wrong device specified" (see man page).

If you need experiment over a memory device, use either ramdisk, scsi_debug module to it.
Another alternative is to create dm-zero device and use plain dm-crypt (not LUKS).

Milan
