From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: [RFC][PATCH 0/4] dm-log: support multi-log devices
Date: Wed, 26 Nov 2008 13:56:27 -0500
Message-ID: <492D9BDB.5010001@cfl.rr.com>
References: <492C91DF.7040507@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <492C91DF.7040507@redhat.com>
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

Takahiro Yasui wrote:
> Hi All,
> 
> This is my first post to this mailing list, but let me introduce
> a patch set to implement multi-log devices for dm-mirror.
> I appreciate your kind comments and suggestions on this patch set.

Does it keep track of which log device corresponds to each mirror device
and make sure that the log on disk X is updated before the data on disk
X?  In other words, if you are about to write data to disk 1 that would
cause that section to be flagged as dirty, you have to update the log on
disk 1 first, not the log on disk 2.

The syntax and the fact that the number of logs does not have to equal
the number of mirrors makes me think this is not the case.
