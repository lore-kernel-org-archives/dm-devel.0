From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH 1/2] Allow the compiler to verify consistency
 of declarations and definitions
Date: Fri, 11 May 2018 20:20:00 +0200
Message-ID: <f411f276-9d0b-a249-2b53-57564c7174d3@gmail.com>
References: <20180319162351.28950-1-bart.vanassche@wdc.com>
	<20180319162351.28950-2-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180319162351.28950-2-bart.vanassche@wdc.com>
Content-Language: en-GB
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@wdc.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

On 03/19/2018 05:23 PM, Bart Van Assche wrote:

> Make sure that in every source file the header file is included that
> declares the functions defined in that source file. This allows the
> compiler to detect inconsistencies between source and header files.
A header sanitizing could be done with iwyu:
https://include-what-you-use.org/
