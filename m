From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 06/15] libmultipath: Remove an unused function
Date: Mon, 24 Oct 2016 09:02:43 -0700
Message-ID: <1b4e7eb8-c033-0f51-a448-0bdeb01f7ddd@sandisk.com>
References: <72bd7a6a-7fb9-5a2c-b22d-031d8feb01b0@sandisk.com>
	<1fcae43b-f64e-7001-ef0d-68ec0585c81d@sandisk.com>
	<2b174b78-f42b-2c7f-90da-00b05cba1f6d@citrix.com>
	<c29b1e88-4dac-9bb7-e701-527cae23dbe6@acm.org>
	<d5cc4da4-3c6a-7bef-aff9-18e40922f07d@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <d5cc4da4-3c6a-7bef-aff9-18e40922f07d@citrix.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Germano Percossi <germano.percossi@citrix.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On 10/24/2016 07:55 AM, Germano Percossi wrote:
> Sorry, my reply was meant for mpath_prin_pthread_fn patch but,
> I guess, given the lack of a declaration in a header file,
> your answer will be the same.

Hello Germano,

Inspection of the git log -p output learned me that also 
mpath_prin_pthread_fn() was never declared in any multipath-tools header 
file.

Bart.
