From: Bernd Zeimetz <bernd@bzed.de>
Subject: Re: Fwd: IO error on DM device
Date: Fri, 31 Mar 2006 00:48:56 +0200
Message-ID: <442C6058.2060006@bzed.de>
References: <39daa5689df1bf4a05a144891cc3563d@redhat.com>
	<442C2AAC.1020405@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <442C2AAC.1020405@redhat.com>
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

Hi,
> So based on the comments below and steps to reproduce, I'd say this is 
> expected behavior since multipathd is turned off. What happens if 
> multipathd is left running? It is implied that not stopping multipathd 
> will still cause a failure but will take much longer. I am no expert 
> on multipathd, so perhaps one of the dm developers can comment on 
> multipathd handling these SCSI error.
Unfortunately I've seen these errors occuring with an EMC CX attached to 
a single host, which was running multipath, too. It happened very, very 
rarely and just completely random. I didn't find any way to make it 
reproducible.


Best regards,


Bernd
