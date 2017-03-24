From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: Question about merge performance
Date: Fri, 24 Mar 2017 10:43:24 +0100
Message-ID: <d47f3058-5bb8-b6a6-92bf-a01f7de4fa9c@redhat.com>
References: <CALpM8gRZoJLQvNxo=K=+JZ4yHAzMxzvDS9aM7uYxyrq8VqzUvg@mail.gmail.com>
	<e25beb09-f4b0-899b-134a-c30d81d74926@redhat.com>
	<CALpM8gR9h5YdQW_QCfxG8UxX-ZygoNv6ySgYot0fX2DSRpOJig@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CALpM8gR9h5YdQW_QCfxG8UxX-ZygoNv6ySgYot0fX2DSRpOJig@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Michael McCarthy <mccarthy197310@gmail.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Dne 24.3.2017 v 03:29 Michael McCarthy napsal(a):
> I appreciate the insight. Are there any plans to enhance the code to allow
> more parallel execution and/or allow users to experiment with QD?
>

Nope there are no plans to enhance old snapshot target - it would essentially 
means to write completely new version of it - as the metadata format is in 
general not enhancable.

Also you should be aware the whole development is focused on 
thin-provisioning, where all this snapshotting & merging as way more efficient.

So old-snapshot should be used in couple 'corner' cases where it does make
sense and user eventually need to pay penalty in terms of performance and
if user needs 'speed' he should look at thin provisioning, where he also 
automatically get  things like snapshot of snapshots and so on....

Regards

Zdenek
