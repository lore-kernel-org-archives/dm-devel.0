From: John Hughes <john@Calva.COM>
Subject: Re: multipath - AAArgh! How do I turn
	"features=1	queue_if_no_path" off?
Date: Wed, 30 Sep 2009 19:11:10 +0200
Message-ID: <4AC3912E.3060908@Calva.COM>
References: <4AC333E2.9090005@Calva.COM>
	<E463DF2B2E584B4A82673F53D62C2EF474E780A7@cosmail01.lsi.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF474E780A7@cosmail01.lsi.com>
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

Moger, Babu wrote:
> You will see "features=1 queue_if_no_path" if you have one of the following entry in your multipath.conf.
>
> 1. Features		"1 queue_if_no_path"
>
>   Or
>
> 2. no_path_retry           5
>   
Ah, that was the problem.   Now I have "features=0".

I did my silly test again (deleting a LUN that was in use from the 
external cabinet) and the system kept working.  The errors on the dm-xxx 
device propogated back to mdadm which marked it as failed an all was well.

Except that I'm still getting lots of I/O errors:

[ 9019.822396] Buffer I/O error on device dm-17, logical block 17790463
[ 9019.822432] Buffer I/O error on device dm-17, logical block 0
[ 9019.822473] Buffer I/O error on device dm-17, logical block 0
[ 9020.735190] sd 4:0:0:1: queueing MODE_SELECT command.
[ 9020.771075] sd 4:0:0:1: MODE_SELECT failed with sense 0x59100.
[ 9020.793828] sd 4:0:0:1: [sdah] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
[ 9020.793894] sd 4:0:0:1: [sdah] Sense Key : Illegal Request [current] 
[ 9020.793932] sd 4:0:0:1: [sdah] Add. Sense: Logical unit not supported
[ 9020.793968] end_request: I/O error, dev sdah, sector 0
[ 9020.793995] device-mapper: multipath: Failing path 66:16.

... endlessly repeating

I was able to stop the errors by

   1. removing the failed multipath from the mdadm array
   2. using the multipath -f command to flush the deleted disk.
