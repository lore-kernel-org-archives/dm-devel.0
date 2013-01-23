From: Spelic <spelic@shiftmail.org>
Subject: Re: dm-integrity: integrity protection device-mapper
	target
Date: Wed, 23 Jan 2013 10:15:09 +0100
Message-ID: <50FFAA1D.8090402@shiftmail.org>
References: <Pine.LNX.4.64.1301151955280.7468@file.rdu.redhat.com>
	<CALLzPKZVo3ng=Hz4cg0qrw0nDYsPjKy5AR=AJtMg+3PU=epz1w@mail.gmail.com>
	<Pine.LNX.4.64.1301221928350.21650@file.rdu.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.1301221928350.21650@file.rdu.redhat.com>
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
List-Id: dm-devel.ids

On 01/23/13 02:29, Mikulas Patocka wrote:
> I am thinking about possibly rewriting it so that it has two hashes 
> per sector so that if either old or new data is read, at least one 
> hash matches and it won't result in data corruption. Mikulas 

Seems like a great idea, but have you thought that for it to work the 
new hash block has to be written before the new data block?

A naiive implementation would send a stream of flush requests and 
completely screw up the disk write cache...

It would be great if Linux could use ordered SCSI commands (that would 
be a feature of the disk but only of SCSI ones AFAIK, correct me if I am 
wrong) or had threaded I/O commands (that could be a feature of the 
elevator methinks) so implement dependencies among write commands and 
not completely screw up the disk cache like above. Is there any plan to 
do that?
